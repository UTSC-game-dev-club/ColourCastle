# on top left, press 'File', and press 'run' to run this file
# this file creates a new level, based on given inputs

@tool extends EditorScript

class_name BaseLevelGeneratorScript

const BASE_LEVEL_PATH: String = "res://game/levels/base_level.tscn"
const TARGET_LEVEL_PATH: String = "res://game/levels/levels/"

#_____________________________________________________#
# modify entries here:
var target_level_name: String = "level1.tscn"
var level_width: float = 100.0
#_____________________________________________________#

func _run() -> void:
	if ResourceLoader.exists(TARGET_LEVEL_PATH + target_level_name):
		push_error("file already exists!")
		return
	
	print("attempt to create level...")
	
	var scene: PackedScene = load(BASE_LEVEL_PATH)
	if scene == null:
		push_error("unable to load level at: %s" % BASE_LEVEL_PATH)
		return
	
	print("load complete")
	
	print("instantiation level...")
	var level: Level = scene.instantiate()
	if !level:
		push_error("instantiation failed")
		return
	
	var floor_plane: CSGMesh3D = level.get_node("FloorPlane")
	var wall_plane: CSGMesh3D = level.get_node("WallPlane")
	var game_camera: Camera3D = level.get_node("Camera")
	if !floor_plane or !wall_plane or !game_camera:
		push_error("unable to find required level nodes")
		level.free()
		return
	
	var floor_mesh: BoxMesh = floor_plane.mesh.duplicate()
	var wall_mesh: BoxMesh = wall_plane.mesh.duplicate()
	floor_mesh.size = Vector3(level_width, 1, level_width)
	wall_mesh.size = Vector3(level_width, level_width, 1)
	floor_plane.mesh = floor_mesh
	wall_plane.mesh = wall_mesh
	floor_plane.position = Vector3(0, 0, level_width / 2.0)
	wall_plane.position = Vector3(0, level_width / 2, 0)
	game_camera.size = level_width
	game_camera.game_width = level_width
	game_camera.position = Vector3(0, level_width / 2, level_width)
	
	var packed_scene := PackedScene.new()
	var pack_error: Error = packed_scene.pack(level)
	if pack_error != OK:
		push_error("unable to pack level")
		level.free()
		return
	
	var error: Error = ResourceSaver.save(packed_scene, TARGET_LEVEL_PATH + target_level_name)
	level.free()
	if error != OK:
		push_error("unable to save level")
		return
	
	print("save complete")
