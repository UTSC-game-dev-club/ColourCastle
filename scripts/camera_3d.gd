extends Camera3D

class_name PlayerCamera

@export var player_distance: float

func set_topdown() -> void:
	position = Vector3(0, player_distance, 0)
	rotation = Vector3(3 * PI / 2, 0, 0)

func set_sidescroller() -> void:
	position = Vector3(0, 0, player_distance)
	rotation = Vector3(0, 0, 0)
