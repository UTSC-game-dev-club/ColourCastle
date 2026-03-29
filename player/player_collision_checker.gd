# responsible for checking if player is able to move towards a certain direction,
# given input displacement vector

extends Node3D

class_name PlayerCollisionChecker

@export var h_raycasts: Array[RayCast3D]
@export var v_raycasts: Array[RayCast3D]

#func _process(_delta: float) -> void:
	#for raycast in h_raycasts:
		#if raycast.is_colliding():
			#
			#if raycast.get_collider() is LevelObjectComponent && raycast.get_collision_point().z - global_position.z >= 250:
				#var collider: LevelObjectComponent = raycast.get_collider()
				#collider.apply_blur()

# checks if the player's current displacement, in sidescroller world, collides with any object
# return the allowed displacement vector, falling back to one axis if needed
# expects displacement.z == 0
func can_move_sidescroller(displacement: Vector3) -> Vector3:
	assert(displacement.z == 0)
	
	var temp_raycast: RayCast3D = h_raycasts[0] # an arbitrary raycast we choose
	temp_raycast.force_raycast_update()
	if !temp_raycast.is_colliding():
		return Vector3.ZERO
		
	assert(temp_raycast.get_collider() is LevelObject)
	var current_color_enum: ColorManager.ColorEnum = temp_raycast.get_collider().color_enum
	
	for attempted_displacement: Vector3 in [displacement, Vector3(displacement.x, 0, 0), Vector3(0, displacement.y, 0)]:
		var can_move: bool = true
		for raycast: RayCast3D in h_raycasts:
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

# checks if the player's current displacement, in topdown world, collides with any object
# return the allowed displacement vector, falling back to one axis if needed
# expects displacement.y == 0
func can_move_topdown(displacement: Vector3) -> Vector3:
	assert(displacement.y == 0)
	
	var temp_raycast: RayCast3D = v_raycasts[0] # an arbitrary raycast we choose
	if !temp_raycast.is_colliding():
		return Vector3.ZERO
		
	assert(temp_raycast.get_collider() is LevelObject)
	var current_color_enum: ColorManager.ColorEnum = temp_raycast.get_collider().color_enum
	
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
