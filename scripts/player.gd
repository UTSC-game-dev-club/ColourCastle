extends CharacterBody3D

class_name Player

@export_group("")
@export var speed: float
@export var jump_velocity: float

@onready var gravity: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")
@onready var game: Game = null

func _ready() -> void:
	game = get_tree().current_scene as Game

func handle_input_sidescroller(_delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	
	if Input.is_action_pressed("left"):
		rotation = Vector3(0, PI, 0)
		velocity.x = -speed
	elif Input.is_action_pressed("right"):
		rotation = Vector3(0, 0, 0)
		velocity.x = speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	

func handle_input_topdown(_delta: float) -> void:
	velocity.x = 0
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	
	rotation.y = atan2(-direction.y, direction.x)

func _physics_process(delta: float) -> void:
	
	# toggle camera
	if game.get_persepective() == Enums.Perspective.SIDESCROLLER:
		handle_input_sidescroller(delta)
	elif game.get_persepective() == Enums.Perspective.TOPDOWN:
		handle_input_topdown(delta)
	
	velocity.y -= gravity * delta
	
	move_and_slide()
