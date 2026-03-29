# eh not really implemented yet, an animating 3D model representing starting point
# or end point of the level

extends CSGCombiner3D

class_name LevelConnector

@export var csg_torus_3d: CSGTorus3D

func _process(delta: float) -> void:
	csg_torus_3d.rotate_y(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("player entered: ", self)
		# move on to the previous/next level
		pass

func _to_string() -> String:
	return name
