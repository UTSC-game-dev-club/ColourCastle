extends Node3D

class_name Level

@onready var background_color_enum: ColorManager.ColorEnum = ColorManager.starting_background_color

@export var floor_plane: LevelSurface
@export var wall_plane: LevelSurface
@export var level_camera: LevelCamera

var shapes: Array[CSGShape3D]

func _ready() -> void:
	assert(floor_plane)
	assert(wall_plane)
	assert(level_camera)
	floor_plane.change_color(background_color_enum)
	wall_plane.change_color(background_color_enum)
	
	for child: Node in get_children():
		if child is LevelObject:
			shapes.append(child)
	
	GamePerspective.game_start() # remove this line in the future, game should be started from outside

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("change_color"):
		background_color_enum = (background_color_enum + 1) % ColorManager.ColorEnum.size() as ColorManager.ColorEnum
		floor_plane.change_color(background_color_enum)
		wall_plane.change_color(background_color_enum)
	if Input.is_action_just_pressed("change_perspective"):
		var game_perspective: GamePerspective.Perspective = GamePerspective.get_perspective()
		if game_perspective == GamePerspective.Perspective.SIDESCROLLER:
			GamePerspective.set_perspective(GamePerspective.Perspective.SIDESCROLLER_TO_TOPDOWN)
			await level_camera.transition_to_topdown()
			GamePerspective.set_perspective(GamePerspective.Perspective.TOPDOWN)
		elif game_perspective == GamePerspective.Perspective.TOPDOWN:
			GamePerspective.set_perspective(GamePerspective.Perspective.TOPDOWN_TO_SIDESCROLLER)
			await level_camera.transition_to_sidescroller()
			GamePerspective.set_perspective(GamePerspective.Perspective.SIDESCROLLER)
	
