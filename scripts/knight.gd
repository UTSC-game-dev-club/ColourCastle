extends Node3D

func make_black(node: Node) -> void:
	if node is MeshInstance3D:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color.BLACK
		node.material_override = mat
	
	for child in node.get_children():
		make_black(child)

func _ready() -> void:
	make_black(self)
