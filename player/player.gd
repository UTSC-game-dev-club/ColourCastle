# the player itself, handles both it's 3D model and hitbox, hitbox is modeled from raycasts
# raycasts (for collision detecting) are by default 500 long, and positioned 250m away from player
# in other words, level's dimension should not exceed 250 for y and z
# players are by default rectangular prisms centered at origin, same goes with it's raycasts
# current player dimension: 2 * 4 * 2
extends Node3D

class_name Player

@export_group("")
@export var speed: float = 20.0
@export var jump_velocity: float = 14.0

@export_group("FIXED")
@export var player_collision_checker: PlayerCollisionChecker
@export var visual_model: Node3D

@onready var velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	GamePerspective.perspective_change.connect(_on_perspective_change)
	
	assert(get_parent() is Level)


func _physics_process(delta: float) -> void:
	var perspective: GamePerspective.Perspective = GamePerspective.get_perspective()
	
	if perspective == GamePerspective.Perspective.SIDESCROLLER:
		handle_sidescroller(delta)
		
	elif perspective == GamePerspective.Perspective.TOPDOWN:
		handle_topdown(delta)

func _on_perspective_change() -> void:
	var perspective: GamePerspective.Perspective = GamePerspective.get_perspective()
	var level: Level = get_tree().current_scene as Level
	if perspective == GamePerspective.Perspective.SIDESCROLLER_TO_TOPDOWN:
		var new_position: Vector3 = player_collision_checker.get_relative_topdown_position()
		player_collision_checker.global_position = new_position
		visual_model.global_position = new_position
		velocity = Vector3.ZERO
	elif perspective == GamePerspective.Perspective.TOPDOWN_TO_SIDESCROLLER:
		var new_position: Vector3 = player_collision_checker.get_relative_sidescroller_position()
		player_collision_checker.global_position = new_position
		visual_model.global_position = new_position
		velocity = Vector3.ZERO
	elif perspective == GamePerspective.Perspective.SIDESCROLLER:
		visual_model.global_position.z = level.level_camera.game_width - 5
	elif perspective == GamePerspective.Perspective.TOPDOWN:
		visual_model.global_position.y = level.level_camera.game_width - 5


func handle_sidescroller(delta: float) -> void:
	velocity.x = 0
	
	var is_grounded: bool = player_collision_checker.is_grounded_sidescroller()
	
	if !is_grounded:
		velocity.y -= ProjectSettings.get_setting(&"physics/3d/default_gravity") * delta
	else:
		velocity.y = 0
	
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		visual_model.rotation = Vector3(0, PI, 0)
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		visual_model.rotation = Vector3(0, 0, 0)
	
	if Input.is_action_just_pressed("jump") and is_grounded:
		velocity.y = jump_velocity
	
	var move_x: Vector3 = player_collision_checker.get_move_sidescroller_x(velocity.x * delta)
	var move_y: Vector3 = player_collision_checker.get_move_sidescroller_y(velocity.y * delta)
	var displacement: Vector3 = move_x + move_y
	
	visual_model.position += displacement
	player_collision_checker.position += displacement
	
	if move_y.y == 0 and velocity.y < 0:
		velocity.y = 0

func handle_topdown(delta: float) -> void:
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity.x = direction_vector.x * speed
	velocity.z = direction_vector.y * speed
	
	if direction_vector != Vector2.ZERO:
		visual_model.rotation.y = atan2(-direction_vector.y, direction_vector.x)
	
	var displacement: Vector3 = player_collision_checker.get_move_topdown(velocity * delta)
	visual_model.position += displacement
	player_collision_checker.position += displacement
