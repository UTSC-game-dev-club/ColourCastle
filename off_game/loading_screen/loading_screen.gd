# only used by autoload scene_manager, handles scene loading + playing animation
# emits loading_complete signal for scene_manager to have an instance of the new node
# for the scene tree

extends Control
class_name LoadingScreen

@export var progress_bar: ProgressBar
var progress: Array[float] = [0.0]

var current_scene_enum: SceneManager.SceneEnum

signal loading_complete(node: Node)

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	# play some kinda animation here
	
	progress_bar.value = progress[0]
	
	assert(current_scene_enum in SceneManager.SceneEnum.values())
	
	var target_path: StringName = SceneManager.scene_enum_dictionary.get(current_scene_enum)
	var status: ResourceLoader.ThreadLoadStatus 
	status = ResourceLoader.load_threaded_get_status(target_path, progress)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var target_scene: PackedScene = ResourceLoader.load_threaded_get(target_path)
		loading_complete.emit(target_scene.instantiate())
		set_process(false)
	elif status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		printerr("invalid resource for threaded load: %s" % target_path)
		loading_complete.emit(null)
		set_process(false)
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("unable to load scene")
		loading_complete.emit(null)
		set_process(false)

func load_scene(scene_enum: SceneManager.SceneEnum) -> void:
	current_scene_enum = scene_enum
	var target_path: StringName = SceneManager.scene_enum_dictionary.get(scene_enum)
	var error: Error = ResourceLoader.load_threaded_request(target_path)
	if error != OK:
		printerr("unable to request threaded load for scene: %s" % target_path)
		loading_complete.emit(null)
		return
	
	set_process(true)
