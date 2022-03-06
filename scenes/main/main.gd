extends Spatial


func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _ready():
	var building_scene = preload("res://scenes/common/prefabs/building.tscn")
	var building1 = building_scene.instance()
	var building2 = building_scene.instance()
	var building3 = building_scene.instance()
	
	building1.transform.origin = Vector3(-5.0, 0.0, 0.0)
	building3.transform.origin = Vector3( 5.0, 0.0, 0.0)

	add_child(building1)
	add_child(building2)
	add_child(building3)
