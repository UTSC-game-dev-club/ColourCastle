# responsible for the camera's transition when changing perspective
# camera transition takes 0.8 seconds

extends Camera3D

class_name LevelCamera

@export var game_width: float = 50.0
@onready var position_sidescroller: Vector3
@onready var position_topdown: Vector3

func _ready() -> void:
	position_sidescroller = Vector3(0, game_width / 2, game_width)
	position_topdown = Vector3(0, game_width, game_width / 2)
	position = position_sidescroller

func transition_to_sidescroller() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(self, "position", position_sidescroller, 0.8)
	tween.parallel().tween_property(self, "rotation", Vector3(0, 0, 0), 0.8)
	
	await tween.finished

func transition_to_topdown() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(self, "position", position_topdown, 0.8)
	tween.parallel().tween_property(self, "rotation", Vector3(-PI / 2, 0, 0), 0.8)
	
	await tween.finished
