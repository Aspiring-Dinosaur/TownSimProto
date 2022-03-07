extends Spatial


export(Color) var mat_color = Color(1.0, 0.0, 1.0, 1.0)


func _ready():
	# Remember to set the Resource/Local To Scene to On under the Material,
	# otherwise all instances will have the same material and therefore
	# the same color.
	$MeshInstance.get_active_material(0).albedo_color = mat_color
