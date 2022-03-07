extends Spatial

export var _pan_speed: float = 12.0
export var _zoom_speed: float = 2.0
export var _boom_min_y: float = 4.0
export var _boom_max_y: float = 32.0

var _boom_tilt_max: float = TAU / 4.0 - TAU / 32.0
var _boom_tilt_min: float = 0.0

export(float) var _boom_tilt_max_deg = _boom_tilt_max setget _set_boom_tilt_max_deg, _get_boom_tilt_max_deg
export(float) var _boom_tilt_min_deg = _boom_tilt_min setget _set_boom_tilt_min_deg, _get_boom_tilt_min_deg

var _boom_rotation_speed: float = 0.005

var _pan_direction: Vector3 = Vector3.ZERO
var _boom_rotation: Vector3 = Vector3.ZERO

var _is_middle_mouse_held: bool = false

onready var _lookat = $LookAt
onready var _camera_boom = $LookAt/CameraBoom

# TODO: implement a soft, over time rotate when pressing Q/E or
# camera_rotate_left/_right

func _input(event):
	# Zooms the camera in and out
	if event.is_action_pressed("camera_zoom_in"):
		_camera_boom.translation.y -= _zoom_speed
	if event.is_action_pressed("camera_zoom_out"):
		_camera_boom.translation.y += _zoom_speed

	# Check if the user pressed or released the middle mouse button
	if event is InputEventMouseButton and event.is_action("camera_rotate"):
		_is_middle_mouse_held = event.is_pressed()
	
	# Check for mouse movements while the middle mouse button is held
	if event is InputEventMouseMotion and _is_middle_mouse_held:
		_boom_rotation.x -= event.relative.y * _boom_rotation_speed
		_boom_rotation.y -= event.relative.x * _boom_rotation_speed
	
	# Clamp the camera zoom basically
	_camera_boom.translation.y = clamp(_camera_boom.translation.y, _boom_min_y, _boom_max_y)
	# The x-rotation is the tilt of the camera, only want to keep it between
	# specific values
	_boom_rotation.x = clamp(_boom_rotation.x, _boom_tilt_min, _boom_tilt_max)
	# Tries to keep the y-rotation between 0 and TAU
	_boom_rotation.y = fposmod(_boom_rotation.y, TAU)


func _process(delta):
	_update_input()
	
	if _pan_direction != Vector3.ZERO:
		self.translate(_pan_direction * _pan_speed * delta)
	
	_lookat.rotation = _boom_rotation


# Checks the input for camera panning and updates pan_direction accordingly.
func _update_input() -> void:
	_pan_direction = Vector3.ZERO
	
	if Input.is_action_pressed("camera_pan_left"):
		_pan_direction += Vector3.LEFT
	if Input.is_action_pressed("camera_pan_right"):
		_pan_direction += Vector3.RIGHT
	
	if Input.is_action_pressed("camera_pan_up"):
		_pan_direction += Vector3.FORWARD
	if Input.is_action_pressed("camera_pan_down"):
		_pan_direction += Vector3.BACK
	
	# First rotate the direction we are moving the camera around
	# the Y-axis (UP), then normalize it sinze we only care about
	# the direction it's pointing. The speed (ie length of the vector)
	# the camera is moving at is handled elsewhere
	_pan_direction = _pan_direction.rotated(
			Vector3.UP, _boom_rotation.y
			).normalized()


func _set_boom_tilt_max_deg(value) -> void:
	_boom_tilt_max = deg2rad(value)

func _get_boom_tilt_max_deg() -> float:
	return rad2deg(_boom_tilt_max)

func _set_boom_tilt_min_deg(value) -> void:
	_boom_tilt_min = deg2rad(value)

func _get_boom_tilt_min_deg() -> float:
	return rad2deg(_boom_tilt_min)
