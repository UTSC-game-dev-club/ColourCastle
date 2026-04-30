class_name OffGamePlayer

extends CharacterBody3D

@export var speed: float

func _physics_process(_delta: float) -> void:
	var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity.x = direction_vector.x * speed
	velocity.z = direction_vector.y * speed
	
	move_and_slide()
