# entry point of game
# not documented yet...

extends Control

class_name MainMenu

@export var colour_rect: ColorRect
@onready var t: float = 0.0
@onready var multiplier: int = 1

func _on_button_pressed() -> void:
	# go to the level select scene
	SceneManager.switch_scene(SceneManager.SceneEnum.LEVEL_SELECT)

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()


func _process(delta: float) -> void:
	colour_rect.modulate = Color(t, t, t, t)
	
	t += multiplier * delta
	
	if t >= 0.3:
		multiplier = -1
	elif t <= 0.0:
		multiplier = 1
