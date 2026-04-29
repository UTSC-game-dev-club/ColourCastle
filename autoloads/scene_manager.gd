# an autoload used to change scene for the game
# usage is documented in readme due to how important it is

extends Node

# general pattern:
# chapter 1: 100-199
# chapter 2: 200-299
# chapter 3: 300-399
# chapter 4...
# 0-99 for everything else
enum SceneEnum {
	NONE = -1,
	MAIN_MENU = 0,
	CHAPTER_SELECT = 1,
	LEVEL_SELECT = 2,
	LOADING_SCREEN = 10,
}

# maps from the scene_enum to the string name of the target scene
var scene_enum_dictionary: Dictionary[SceneEnum, StringName] = {
	SceneEnum.NONE: &"",
	SceneEnum.MAIN_MENU: &"uid://boihka0gt0lgg",
	SceneEnum.CHAPTER_SELECT: &"uid://bgo7e6a80racw",
	SceneEnum.LEVEL_SELECT: &"uid://c86pbsftaqd3v",
	SceneEnum.LOADING_SCREEN: &"uid://bpe5d70ww2nm8",
}

var loading_screen_scene: PackedScene = load(scene_enum_dictionary.get(SceneEnum.LOADING_SCREEN))

# the only function that needs to be invoked
# changes the current scene to the target scene
# uses loading_screen scene during the loading process, which plays an animation
func switch_scene(scene_enum: SceneEnum) -> void:
	assert(loading_screen_scene)
	
	var loading_screen: LoadingScreen = loading_screen_scene.instantiate()
	assert(loading_screen)
	
	get_tree().change_scene_to_node(loading_screen)
	loading_screen.load_scene(scene_enum)
	
	var target_node: Node = await loading_screen.loading_complete
	assert(target_node)
	get_tree().change_scene_to_node(target_node)
