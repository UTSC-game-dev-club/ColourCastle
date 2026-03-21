extends CharacterBody3D

class_name Player

@export_group("")
@export var speed: float
@export var jump_velocity: float
@onready var is_side_scroller: bool = true # true means start as sidescroller

@onready var gravity: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")

func _ready() -> void:
	pass

func handle_input_sidescroller() -> void:
	velocity.x = 0
	velocity.z = 0
	if Input.is_action_pressed("left"):
		velocity.x = speed
	elif Input.is_action_pressed("right"):
		velocity.x = -speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	

func handle_input_topdown() -> void:
	velocity.x = 0
	velocity.y = 0
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	
	#if Input.is_action_just_pressed("camera_toggle"):
		#camera.set_sidescroller()
		#is_side_scroller = !is_side_scroller

func _physics_process(delta: float) -> void:
	
	# toggle camera
	if is_side_scroller:
		handle_input_sidescroller()
	else:
		handle_input_topdown()
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
