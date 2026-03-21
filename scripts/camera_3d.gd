extends Camera3D

func _ready() -> void:
	
	# Set to Orthogonal
	projection = Camera3D.PROJECTION_ORTHOGONAL
	
	# Set the size (vertical units visible)
	size = 10.0
	
	# Optional: Adjust far/near planes
	far = 100.0
	near = 0.1
