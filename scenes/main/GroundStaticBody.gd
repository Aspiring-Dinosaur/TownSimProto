extends StaticBody

onready var main = $".."

func _input_event(camera, event, position, normal, shape_idx):
	main.move_current_building(position)
