# some invariants about each room:
# the "intersection" of FloorBox and WallPlane is the line (x, y, z) = t(0, 1, 0)

extends Node3D
class_name Game

@onready var background_color_enum: Enums.ColorEnum = Enums.ColorEnum.WHITE
@onready var perspective: Enums.Perspective = Enums.starting_perspective:
	set(new_perspective):
		perspective = new_perspective
		change_perspective.emit(new_perspective)

signal change_perspective(new_perspective: Enums.Perspective)

@export_group("FIXED")
@export var floor_plane: GameSurfaceComponent
@export var wall_plane: GameSurfaceComponent
@export var game_camera: GameCamera

@export_group("")
@export var raycast_offset: float

func _ready() -> void:
	assert(floor_plane)
	assert(wall_plane)
	floor_plane.change_color(background_color_enum)
	wall_plane.change_color(background_color_enum)

func get_color_enum() -> Enums.ColorEnum:
	return background_color_enum

func get_persepective() -> Enums.Perspective:
	return perspective

func get_raycast_offset() -> float:
	return raycast_offset

func get_floor_plane_y() -> float:
	return floor_plane.position.y

func get_wall_plane_x() -> float:
	return floor_plane.position.x

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_color"):
		background_color_enum = (background_color_enum + 1) % Enums.ColorEnum.size() as Enums.ColorEnum
		floor_plane.change_color(background_color_enum)
		wall_plane.change_color(background_color_enum)
	if Input.is_action_just_pressed("change_perspective"):
		match perspective:
			Enums.Perspective.TRANSITIONING:
				return
			Enums.Perspective.SIDESCROLLER:
				perspective = Enums.Perspective.TRANSITIONING
				await game_camera.transition_to_topdown()
				perspective = Enums.Perspective.TOPDOWN
			Enums.Perspective.TOPDOWN:
				perspective = Enums.Perspective.TRANSITIONING
				await game_camera.transition_to_sidescroller()
				perspective = Enums.Perspective.SIDESCROLLER
