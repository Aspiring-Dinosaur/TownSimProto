extends Spatial

var _mat_color = Vector3(255, 0, 255)
var mat_color: Vector3:
	get:
		return _mat_color
	set(value):
		_mat_color = value
	
