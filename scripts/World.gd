extends Spatial

func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
