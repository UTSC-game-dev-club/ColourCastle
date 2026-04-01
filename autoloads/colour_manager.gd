extends Node

# use apply color to change the color of a LevelObject (or CSG_Shape3D in general)

enum ColorEnum {
	WHITE = 0,
	RED = 1,
	YELLOW = 2,
	GREEN = 3,
	PINK = 4,
}

var starting_background_color: ColorEnum = ColorEnum.WHITE

var color_dictionary: Dictionary[ColorEnum, Color] = {
	ColorEnum.WHITE: Color(1, 1, 1),
	ColorEnum.RED: Color(1, 0.4, 0.4),
	ColorEnum.YELLOW: Color(1, 1, 0.3),
	ColorEnum.GREEN: Color(0, 1, 0.3),
	ColorEnum.PINK: Color(1, 0.2, 0.6),
}

func apply_color(CSG_shape: CSGShape3D, color_enum: ColorEnum) -> void:
	var material: Material = StandardMaterial3D.new()
	material.albedo_color = color_dictionary[color_enum]
	CSG_shape.material_override = material
