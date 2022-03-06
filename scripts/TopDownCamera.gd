extends Spatial

export var _pan_speed: float = 12.0
export var _zoom_speed: float = 2.0
export var _boom_min_y: float = 4.0
export var _boom_max_y: float = 32.0

export var _boom_tilt_max_deg: float setget _set_boom_tilt_max_deg, _get_boom_tilt_max_deg
export var _boom_tilt_min_deg: float setget _set_boom_tilt_min_deg, _get_boom_tilt_min_deg

var _boom_tilt_max: float = TAU / 4.0
var _boom_tilt_min: float = 0.0

var _boom_rotation_speed: float = 0.005

var _pan_direction: Vector3 = Vector3.ZERO
var _boom_rotation: Vector3 = Vector3.ZERO

var _is_middle_mouse_held: bool = false

onready var _boom = $Boom

# TODO: fix the camera zoom. Right now it just moves the camera towards the
# "ground", not towards where it's pointing. Set up Q and E maybe to have the
# same effect, or just remove it. Maybe need to add a new Spatial node that
# the boom is a child of which is the one that is moved (panned)

func _input(event):
	# Zooms the camera in and out
	if event.is_action_pressed("zoom_in"):
		_boom.translation.y -= _zoom_speed
	if event.is_action_pressed("zoom_out"):
		_boom.translation.y += _zoom_speed
	
	# Check if the user pressed or released the middle mouse button
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		_is_middle_mouse_held = event.is_pressed()
	
	# Check for mouse movements while the middle mouse button is held
	if event is InputEventMouseMotion and _is_middle_mouse_held:
		_boom_rotation.x -= event.relative.y * _boom_rotation_speed
		_boom_rotation.y -= event.relative.x * _boom_rotation_speed
	
	# Clamp the camera zoom basically
	_boom.translation.y = clamp(_boom.translation.y, _boom_min_y, _boom_max_y)
	# The x-rotation is the tilt of the camera, only want to keep it between
	# specific values
	_boom_rotation.x = clamp(_boom_rotation.x, _boom_tilt_min, _boom_tilt_max)
	# Tries to keep the y-rotation between 0 and TAU
	_boom_rotation.y = _fix_angle(_boom_rotation.y)


func _process(delta):
	_update_input()
	
	if _pan_direction != Vector3.ZERO:
		self.translate(_pan_direction * _pan_speed * delta)
	
	_boom.rotation = _boom_rotation


# Checks the input for camera panning and updates pan_direction accordingly.
func _update_input() -> void:
	_pan_direction = Vector3.ZERO
	
	if Input.is_action_pressed("pan_left"):
		_pan_direction += Vector3.LEFT
	if Input.is_action_pressed("pan_right"):
		_pan_direction += Vector3.RIGHT
	
	if Input.is_action_pressed("pan_up"):
		_pan_direction += Vector3.FORWARD
	if Input.is_action_pressed("pan_down"):
		_pan_direction += Vector3.BACK
	
	# First rotate the direction we are moving the camera around the Y-axis (UP),
	# then normalize it sinze we only care about the direction it's pointing.
	# The speed (ie length of the vector) the camera is moving at is handled elsewhere
	_pan_direction = _pan_direction.rotated(
			Vector3.UP, _boom_rotation.y
			).normalized()


# Tries to keep an angle between 0 and TAU.
# If the angle is <= -2*TAU or >= 2*TAU it will not get all the way there.
func _fix_angle(angle) -> float:
	if angle < 0:
		return angle + TAU
	elif angle > TAU:
		return angle - TAU
	else:
		return angle


func _set_boom_tilt_max_deg(value) -> void:
	_boom_tilt_max = deg2rad(value)

func _get_boom_tilt_max_deg() -> float:
	return rad2deg(_boom_tilt_max)

func _set_boom_tilt_min_deg(value) -> void:
	_boom_tilt_min = deg2rad(value)

func _get_boom_tilt_min_deg() -> float:
	return rad2deg(_boom_tilt_min)
