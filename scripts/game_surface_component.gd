extends CSGBox3D

class_name GameSurfaceComponent

func change_color(color_enum: Enums.ColorEnum) -> void:
	ColorManager.set_color(self, color_enum)
