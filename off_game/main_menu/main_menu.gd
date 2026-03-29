extends Control

class_name MainMenu


func _on_button_pressed() -> void:
	# go to the level select scene
	SceneManager.switch_scene(SceneManager.SceneEnum.CHAPTER_SELECT)
