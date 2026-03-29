extends CSGShape3D

class_name LevelObject

@export var color_enum: ColorManager.ColorEnum

func _ready() -> void:
	use_collision = true
	set_collision_layer_value(2, true)
	ColorManager.apply_color(self, color_enum)

func apply_blur() -> void:
	var alpha: float = 0.3
	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(1, 1, 1, alpha)
	mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_DISABLED
	mat.cull_mode = BaseMaterial3D.CULL_BACK
	mat.roughness = 0.1
	mat.metallic = 0.0
	material_override = mat
	
	var timer: Timer = Timer.new()
	timer.start(2)
	await timer.timeout
	material_override = null
