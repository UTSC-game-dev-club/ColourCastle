# responsible for checking if player is able to move towards a certain direction,
# given input displacement vector

extends Node3D

class_name PlayerCollisionChecker

@export var h_raycasts: Array[RayCast3D]
@export var h_raycast_central: RayCast3D
@export var v_raycasts: Array[RayCast3D]
@export var v_raycast_central: RayCast3D

func _process(_delta: float) -> void:
	for raycast in h_raycasts:
		if raycast.is_colliding():
			
			if raycast.get_collider() is LevelObject && raycast.get_collision_point().z - global_position.z >= 250:
				var collider: LevelObject = raycast.get_collider()
				collider.apply_fade()

func _can_move_sidescroller(displacement: Vector3) -> bool:
	assert(displacement.z == 0)
	
	h_raycast_central.force_raycast_update()
	if !h_raycast_central.is_colliding():
		return false
		
	assert(h_raycast_central.get_collider() is LevelObject)
	var current_color_enum: ColorManager.ColorEnum = h_raycast_central.get_collider().color_enum
	
	for raycast: RayCast3D in h_raycasts:
		raycast.position += displacement
		raycast.force_raycast_update()
		if !raycast.is_colliding():
			raycast.position -= displacement
			return false
		else:
			assert(raycast.get_collider() is LevelObject)
			var collider: LevelObject = raycast.get_collider()
			if collider.color_enum != current_color_enum:
				raycast.position -= displacement
				return false
		raycast.position -= displacement
	return true

# checks horizontal movement in sidescroller world
func get_move_sidescroller_x(displacement_x: float) -> Vector3:
	var displacement := Vector3(displacement_x, 0, 0)
	if _can_move_sidescroller(displacement):
		return displacement
	return Vector3.ZERO

# checks vertical movement in sidescroller world
func get_move_sidescroller_y(displacement_y: float) -> Vector3:
	var displacement := Vector3(0, displacement_y, 0)
	if displacement_y == 0:
		return Vector3.ZERO
	
	var raycasts_to_check: Array = [h_raycasts[2], h_raycasts[5]] if displacement_y > 0 else [h_raycasts[0], h_raycasts[3]]
	for raycast: RayCast3D in raycasts_to_check:
		raycast.force_raycast_update()
		if !raycast.is_colliding():
			return Vector3.ZERO
		
		assert(raycast.get_collider() is LevelObject)
		var current_color_enum: ColorManager.ColorEnum = raycast.get_collider().color_enum
		
		raycast.position += displacement
		raycast.force_raycast_update()
		if !raycast.is_colliding():
			raycast.position -= displacement
			return Vector3.ZERO
		
		assert(raycast.get_collider() is LevelObject)
		var collider: LevelObject = raycast.get_collider()
		raycast.position -= displacement
		if collider.color_enum != current_color_enum:
			return Vector3.ZERO
	
	return displacement

# checks if the player's current displacement, in sidescroller world, collides with any object
# return the allowed displacement vector
# expects displacement.z == 0
func get_move_sidescroller(displacement: Vector3) -> Vector3:
	assert(displacement.z == 0)
	return get_move_sidescroller_x(displacement.x) + get_move_sidescroller_y(displacement.y)

func is_grounded_sidescroller() -> bool:
	return get_move_sidescroller_y(-0.1).y == 0

# checks if the player's current displacement, in topdown world, collides with any object
# return the allowed displacement vector, falling back to one axis if needed
# expects displacement.y == 0
func get_move_topdown(displacement: Vector3) -> Vector3:
	assert(displacement.y == 0)
	
	v_raycast_central.force_raycast_update()
	if !v_raycast_central.is_colliding():
		return Vector3.ZERO
		
	assert(v_raycast_central.get_collider() is LevelObject)
	var current_color_enum: ColorManager.ColorEnum = v_raycast_central.get_collider().color_enum
	
	for attempted_displacement: Vector3 in [displacement, Vector3(displacement.x, 0, 0), Vector3(0, 0, displacement.z)]:
		var can_move: bool = true
		for raycast: RayCast3D in v_raycasts:
			raycast.position += attempted_displacement
			raycast.force_raycast_update()
			if !raycast.is_colliding():
				can_move = false
			else:
				assert(raycast.get_collider() is LevelObject)
				var collider: LevelObject = raycast.get_collider()
				if collider.color_enum != current_color_enum:
					can_move = false
			raycast.position -= attempted_displacement
			if !can_move:
				break
		if can_move:
			return attempted_displacement
	return Vector3.ZERO

# used on switching from topdown to sidescroller
func get_relative_topdown_position() -> Vector3:
	h_raycast_central.force_raycast_update()
	assert(h_raycast_central.is_colliding())
	assert(h_raycast_central.get_collider() is LevelObject)
	
	return h_raycast_central.get_collision_point() + Vector3(0, 0, 1)

# used on switching from sidescroller to topdown
func get_relative_sidescroller_position() -> Vector3:
	v_raycast_central.force_raycast_update()
	assert(v_raycast_central.is_colliding())
	assert(v_raycast_central.get_collider() is LevelObject)
	
	return v_raycast_central.get_collision_point() + Vector3(0, 2, 0)
