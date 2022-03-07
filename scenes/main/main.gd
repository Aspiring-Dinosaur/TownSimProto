extends Spatial

const ray_length = 100.0
var camera: Camera

export var buildings = {}
var current_building: Spatial
var last_build_location: Vector3 = Vector3.ZERO

func _input(event):
	if event.is_action_pressed("quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1:
			set_current_building("proto_house_small")
		elif event.scancode == KEY_2:
			set_current_building("proto_industry_small")
		elif event.scancode == KEY_3:
			set_current_building("proto_shop_small")


func set_current_building(new_building: String):
	free_current_building()
	
	if buildings.has(new_building):
		current_building = buildings[new_building].instance()
		current_building.translation = last_build_location
		add_child(current_building)
		print("Building " + new_building)
	else:
		print("** ERROR ** Unknown building! (" + new_building + ")")


func free_current_building() -> void:
	if current_building != null:
		print("Freeing up building: " + current_building.name)
		current_building.queue_free()


# This is called from the GroundStaticBody's script.
# I don't like it.
func move_current_building(move_to: Vector3):
	last_build_location = move_to
	
	if current_building != null:
		current_building.translation = move_to

func _ready():
#	buildings["proto_home_small"] = preload("res://buildings/proto_house_small/proto_house_small.tscn")
#	buildings["proto_industry_small"] = preload("res://buildings/proto_industry_small/proto_industry_small.tscn")
#	buildings["proto_shop_small"] = preload("res://buildings/proto_shop_small/proto_shop_small.tscn")
	
	camera = $TopDownCamera.camera
