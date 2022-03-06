extends Spatial

const pan_speed = 12.0
const zoom_speed = 2.0
const min_boom_y = 4.0
const max_boom_y = 32.0

var pan_direction = Vector3.ZERO

# TODO: add tilt and y-rotation (right-click and move mouse)

func _input(event):
	if event.is_action_pressed("zoom_in"):
		$Boom.translation.y -= zoom_speed
	if event.is_action_pressed("zoom_out"):
		$Boom.translation.y += zoom_speed
	
	if $Boom.translation.y < min_boom_y:
		$Boom.translation.y = min_boom_y
	elif $Boom.translation.y > max_boom_y:
		$Boom.translation.y = max_boom_y

func _process(delta):
	update_input()
	
	if pan_direction != Vector3.ZERO:
		self.translate(pan_direction * pan_speed * delta)

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
	
	pan_direction = pan_direction.normalized()
