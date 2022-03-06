extends Spatial

const pan_speed: float = 12.0
const zoom_speed: float = 2.0
const boom_min_y: float = 4.0
const boom_max_y: float = 32.0
const boom_tilt_min: float = 0.0
const boom_tilt_max: float = TAU / 4.0
const boom_rotation_speed: float = 0.005

var pan_direction: Vector3 = Vector3.ZERO
var boom_rotation: Vector3 = Vector3.ZERO

var is_middle_mouse_held: bool = false

onready var boom = $Boom

# TODO: fix the camera zoom. Right now it just moves the camera towards the
# "ground", not towards where it's pointing. Set up Q and E maybe to have the
# same effect, or just remove it. Maybe need to add a new Spatial node that
# the boom is a child of which is the one that is moved (panned)

func _input(event):
	# Zooms the camera in and out
	if event.is_action_pressed("zoom_in"):
		boom.translation.y -= zoom_speed
	if event.is_action_pressed("zoom_out"):
		boom.translation.y += zoom_speed
	
	# Check if the user pressed or released the middle mouse button
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		is_middle_mouse_held = event.is_pressed()
	
	# Check for mouse movements while the middle mouse button is held
	if event is InputEventMouseMotion and is_middle_mouse_held:
		boom_rotation.x -= event.relative.y * boom_rotation_speed
		boom_rotation.y -= event.relative.x * boom_rotation_speed
	
	# Clamp the camera zoom basically
	boom.translation.y = clamp(boom.translation.y, boom_min_y, boom_max_y)
	# The x-rotation is the tilt of the camera, only want to keep it between
	# specific values
	boom_rotation.x = clamp(boom_rotation.x, boom_tilt_min, boom_tilt_max)
	# Tries to keep the y-rotation between 0 and TAU
	boom_rotation.y = fix_angle(boom_rotation.y)

func _process(delta):
	update_input()
	
	if pan_direction != Vector3.ZERO:
		self.translate(pan_direction * pan_speed * delta)
	
	boom.rotation = boom_rotation

# Checks the input for camera panning and updates pan_direction accordingly.
func update_input():
	pan_direction = Vector3.ZERO
	
	if Input.is_action_pressed("pan_left"):
		pan_direction += Vector3.LEFT
	if Input.is_action_pressed("pan_right"):
		pan_direction += Vector3.RIGHT
	
	if Input.is_action_pressed("pan_up"):
		pan_direction += Vector3.FORWARD
	if Input.is_action_pressed("pan_down"):
		pan_direction += Vector3.BACK
	
	# First rotate the direction we are moving the camera around the Y-axis (UP),
	# then normalize it sinze we only care about the direction it's pointing.
	# The speed (ie length of the vector) the camera is moving at is handled elsewhere
	pan_direction = pan_direction.rotated(Vector3.UP, boom_rotation.y).normalized()

func fix_angle(angle):
	if angle < 0:
		return angle + TAU
	elif angle > TAU:
		return angle - TAU
	else:
		return angle
