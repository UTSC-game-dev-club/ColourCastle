extends Node3D

class_name Game

@export var ground: CSGShape3D
@export var color_enum: Enums.ColorEnum

func _ready() -> void:
	assert(ground)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("change_color"):
		color_enum = (color_enum + 1) % Enums.ColorEnum.size() as Enums.ColorEnum
		ColorManager.set_color(ground, color_enum)
