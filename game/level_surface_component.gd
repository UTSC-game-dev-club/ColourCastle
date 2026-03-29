extends LevelObject

class_name LevelSurface

func change_color(new_color_enum: ColorManager.ColorEnum) -> void:
	color_enum = new_color_enum
	ColorManager.apply_color(self, new_color_enum)
