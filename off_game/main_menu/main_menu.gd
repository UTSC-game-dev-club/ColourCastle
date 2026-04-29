# entry point of game
# not documented yet...

extends Control

class_name MainMenu


func _on_button_pressed() -> void:
	# go to the level select scene
	SceneManager.switch_scene(SceneManager.SceneEnum.LEVEL_SELECT)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
