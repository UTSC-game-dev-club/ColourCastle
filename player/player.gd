# raycasts (for collision detecting) are by default 500m long, and positioned 250m away from player
# in other words, level's size should not exceed 250m for y and z
extends Node3D

class_name Player


@export_group("")
@export var speed: float = 20.0
@export var jump_velocity: float = 14.0

@export_group("FIXED")
@export var player_collision_checker: PlayerCollisionChecker
@export var visual_model: Node3D

var velocity: Vector3

func _physics_process(delta: float) -> void:
	var perspective: GamePerspective.Perspective = GamePerspective.get_perspective()
	
	if perspective == GamePerspective.Perspective.SIDESCROLLER:
		velocity.x = 0
		velocity.y -= ProjectSettings.get_setting(&"physics/3d/default_gravity") * delta
		
		if Input.is_action_pressed("left"):
			velocity.x = -speed
			visual_model.rotation = Vector3(0, 0, 0)
		elif Input.is_action_pressed("right"):
			velocity.x = speed
			visual_model.rotation = Vector3(0, PI, 0)
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
		
		var displacement: Vector3 = player_collision_checker.can_move_sidescroller(velocity * delta)
		visual_model.position += displacement
		player_collision_checker.position += displacement
		
	elif perspective == GamePerspective.Perspective.TOPDOWN:
		pass

#@export_group("FIXED")
#@export var collision_shape: CollisionShape3D # this is the hitbox of the "visible" part of the player
#@export var visual_model: Node3D # this is the 3D model of the character
#@export var game: Game
#
#@onready var gravity: float = ProjectSettings.get_setting(&"physics/3d/default_gravity")
#@onready var perspective: Enums.Perspective = Enums.starting_perspective
#
#func _ready() -> void:
	#assert(game)
	#game.change_perspective.connect(_on_game_change_perspective)
#
#var is_grounded_custom = false
#
#func _physics_process(delta: float) -> void:
	#
	#match perspective:
		#Enums.Perspective.SIDESCROLLER:
			#velocity.x = 0
			#velocity.z = 0
			#
			#velocity.y -= gravity * delta
			#
			#if Input.is_action_pressed("left"):
				#visual_model.rotation = Vector3(0, PI, 0)
				#if !check_collision_horizontal(-speed, delta):
					#
					#velocity.x = -speed
			#elif Input.is_action_pressed("right"):
				#visual_model.rotation = Vector3(0, 0, 0)
				#if !check_collision_horizontal(speed, delta):
					#velocity.x = speed
			#
			#if velocity.y < 0:
				#if check_collision_vertical(velocity.y, delta):
					#velocity.y = 0
					#is_grounded_custom = true
					#
					#for i in range(20):
						#global_position.y += 0.01
						#if !check_collision_vertical(-0.001, 1.0):
							#break
			#elif velocity.y > 0:
				#if check_collision_vertical(velocity.y, delta):
					#velocity.y = 0
			#if Input.is_action_just_pressed("jump") and (is_on_floor() or is_grounded_custom):
				#velocity.y = jump_velocity
				#is_grounded_custom = false
	#
		#Enums.Perspective.TOPDOWN:
			#velocity.x = 0
			#velocity.z = 0
			#var direction_vector: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
			#if direction_vector != Vector2.ZERO:
				#visual_model.rotation.y = atan2(-direction_vector.y, direction_vector.x)
			#
			# check if to the direction the ray casts to the background colour
			#if !check_collision_topdown(direction_vector.x * speed, direction_vector.y * speed, delta):
				#velocity.x = direction_vector.x * speed
				#velocity.z = direction_vector.y * speed
		#Enums.Perspective.TRANSITIONING:
			#velocity = Vector3.ZERO
	#move_and_slide()
#
#func check_collision_horizontal(vel_x: float, delta: float) -> bool:
	#if vel_x == 0:
		#return false
	#
	#var space_state := get_world_3d().direct_space_state
	#var attempted_move := vel_x * delta
	#
	#var current_origin := global_position + Vector3(0, 0, 100)
	#var current_target := current_origin + Vector3(0, 0, -300)
	#
	#var current_query := PhysicsRayQueryParameters3D.create(current_origin, current_target)
	#current_query.collision_mask = 2
	#current_query.exclude = [self]
	#
	#var current_result := space_state.intersect_ray(current_query)
	#if !current_result:
		#return false
	#
	#var current_collider = current_result["collider"]
	#if !(current_collider is CSGShape3D):
		#return false
	#
	#var current_material: Material = current_collider.material_override
	#if current_material == null:
		#current_material = current_collider.material
	#
	#if !(current_material is BaseMaterial3D):
		#return false
	#
	#var current_color: Color = current_material.albedo_color
	#
	#var intended_origin := global_position + Vector3(attempted_move, 0, 100)
	#var intended_target := intended_origin + Vector3(0, 0, -300)
	#
	#var intended_query := PhysicsRayQueryParameters3D.create(intended_origin, intended_target)
	#intended_query.collision_mask = 2
	#intended_query.exclude = [self]
	#
	#var intended_result := space_state.intersect_ray(intended_query)
	#if !intended_result:
		#return false
	#
	#var intended_collider = intended_result["collider"]
	#if !(intended_collider is CSGShape3D):
		#return false
	#
	#var intended_material: Material = intended_collider.material_override
	#if intended_material == null:
		#intended_material = intended_collider.material
	#
	#if !(intended_material is BaseMaterial3D):
		#return false
	#
	#var intended_color: Color = intended_material.albedo_color
	#
	#return current_color != intended_color
#
#func check_collision_vertical(vel_y: float, delta: float) -> bool:
	#if vel_y == 0:
		#return false
	#
	#var space_state := get_world_3d().direct_space_state
	#var attempted_move := vel_y * delta
	#var dir: float = sign(vel_y)
	#
	## tune this to match the real bottom/top of your body
	#var half_height := 1.5
	#var skin := 0.02
	#
	#var edge_offset := Vector3(0, dir * (half_height + skin), 0)
	#
	#var current_origin := global_position + edge_offset + Vector3(0, 0, 100)
	#var current_target := current_origin + Vector3(0, 0, -300)
	#
	#var current_query := PhysicsRayQueryParameters3D.create(current_origin, current_target)
	#current_query.collision_mask = 2
	#current_query.exclude = [self]
	#
	#var current_result := space_state.intersect_ray(current_query)
	#if !current_result:
		#return false
	#
	#var current_collider = current_result["collider"]
	#if !(current_collider is CSGShape3D):
		#return false
	#
	#var current_material: Material = current_collider.material_override
	#if current_material == null:
		#current_material = current_collider.material
	#
	#if !(current_material is BaseMaterial3D):
		#return false
	#
	#var current_color: Color = current_material.albedo_color
	#
	#var intended_origin := global_position + Vector3(0, attempted_move, 0) + edge_offset + Vector3(0, 0, 100)
	#var intended_target := intended_origin + Vector3(0, 0, -300)
	#
	#var intended_query := PhysicsRayQueryParameters3D.create(intended_origin, intended_target)
	#intended_query.collision_mask = 2
	#intended_query.exclude = [self]
	#
	#var intended_result := space_state.intersect_ray(intended_query)
	#if !intended_result:
		#return false
	#
	#var intended_collider = intended_result["collider"]
	#if !(intended_collider is CSGShape3D):
		#return false
	#
	#var intended_material: Material = intended_collider.material_override
	#if intended_material == null:
		#intended_material = intended_collider.material
	#
	#if !(intended_material is BaseMaterial3D):
		#return false
	#
	#var intended_color: Color = intended_material.albedo_color
	#
	#return current_color != intended_color
#
#func check_collision_topdown(move_x: float, move_z: float, delta: float) -> bool:
	#if move_x == 0 and move_z == 0:
		#return false
	#
	#var space_state := get_world_3d().direct_space_state
	#var attempted_move := Vector3(move_x * delta, 0, move_z * delta)
	#
	#var current_origin := global_position + Vector3(0, 100, 0)
	#var current_target := current_origin + Vector3(0, -200, 0)
	#
	#var current_query := PhysicsRayQueryParameters3D.create(current_origin, current_target)
	#current_query.collision_mask = 2
	#current_query.exclude = [self]
	#
	#var current_result := space_state.intersect_ray(current_query)
	#if !current_result:
		#return false
	#
	#var current_collider = current_result["collider"]
	#if !(current_collider is CSGShape3D):
		#return false
	#
	#var current_material: Material = current_collider.material_override
	#if current_material == null:
		#current_material = current_collider.material
	#
	#if !(current_material is BaseMaterial3D):
		#return false
	#
	#var current_color: Color = current_material.albedo_color
	#
	#var intended_origin := global_position + attempted_move + Vector3(0, 100, 0)
	#var intended_target := intended_origin + Vector3(0, -200, 0)
	#
	#var intended_query := PhysicsRayQueryParameters3D.create(intended_origin, intended_target)
	#intended_query.collision_mask = 2
	#intended_query.exclude = [self]
	#
	#var intended_result := space_state.intersect_ray(intended_query)
	#if !intended_result:
		#return false
	#
	#var intended_collider = intended_result["collider"]
	#if !(intended_collider is CSGShape3D):
		#return false
	#
	#var intended_material: Material = intended_collider.material_override
	#if intended_material == null:
		#intended_material = intended_collider.material
	#
	#if !(intended_material is BaseMaterial3D):
		#return false
	#
	#var intended_color: Color = intended_material.albedo_color
	#
	#return current_color != intended_color
#
#func _on_game_change_perspective(new_perspective: Enums.Perspective) -> void:
	#perspective = new_perspective
	#velocity = Vector3.ZERO
