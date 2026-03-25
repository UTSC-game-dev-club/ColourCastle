extends Node

var color_dictionary: Dictionary[Enums.ColorEnum, Color] = {
	Enums.ColorEnum.WHITE: Color(1, 1, 1),
	Enums.ColorEnum.RED: Color(1, 0, 0.3),
	Enums.ColorEnum.BLUE: Color.SKY_BLUE,
	Enums.ColorEnum.GREEN: Color.PALE_GREEN,
	Enums.ColorEnum.PINK: Color.PINK,
}

func set_color(CSG_shape: CSGShape3D, color_enum: Enums.ColorEnum) -> void:
	var material: Material = StandardMaterial3D.new()
	material.albedo_color = color_dictionary[color_enum]
	CSG_shape.material_override = material
