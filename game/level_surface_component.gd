# used for the floor and wall of the game, able to change colour from the level itself
# everything else works the same as a LevelObject

extends LevelObject

class_name LevelSurface

func change_color(new_color_enum: ColorManager.ColorEnum) -> void:
	color_enum = new_color_enum
	ColorManager.apply_color(self, new_color_enum)
