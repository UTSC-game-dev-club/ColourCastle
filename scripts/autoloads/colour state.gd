extends Node

var color_dictionary: Dictionary[Enums.ColorEnum, Color] = {
	Enums.ColorEnum.WHITE: Color.WHITE,
	Enums.ColorEnum.RED: Color.RED,
	Enums.ColorEnum.BLUE: Color.BLUE,
	Enums.ColorEnum.BLACK: Color.BLACK,
}

func set_color(CSG_shape: CSGShape3D, color_enum: Enums.ColorEnum) -> void:
	var material: Material = StandardMaterial3D.new()
	material.albedo_color = color_dictionary[color_enum]
	CSG_shape.material_override = material
