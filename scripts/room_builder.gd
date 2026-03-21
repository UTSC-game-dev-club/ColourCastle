# (AI GENERAETED CLASS)
# genuinely just builds the basics of the room for you, that is, a rectangular
# prism.
#

@tool
extends Node

class_name RoomBuilder

@export var room_size: Vector3 = Vector3(8.0, 4.0, 6.0):
	set(value):
		room_size = Vector3(
			max(value.x, 0.01),
			max(value.y, 0.01),
			max(value.z, 0.01)
		)
		_rebuild()

@export var wall_thickness: float = 0.2:
	set(value):
		wall_thickness = max(value, 0.01)
		_rebuild()

@export var generate_floor: bool = true:
	set(value):
		generate_floor = value
		_rebuild()

@export var generate_ceiling: bool = true:
	set(value):
		generate_ceiling = value
		_rebuild()

@export var centered_on_origin: bool = true:
	set(value):
		centered_on_origin = value
		_rebuild()

func _ready() -> void:
	if Engine.is_editor_hint():
		_rebuild()

func _notification(what: int) -> void:
	if what == NOTIFICATION_ENTER_TREE and Engine.is_editor_hint():
		call_deferred("_rebuild")

func _rebuild() -> void:
	if not Engine.is_editor_hint():
		return
	
	if not is_inside_tree():
		return
	
	var room_root: Node3D = _get_room_root()
	if room_root == null:
		return
	
	var geometry_root: Node3D = _get_geometry_root(room_root)
	
	_update_floor(geometry_root)
	_update_ceiling(geometry_root)
	_update_left_wall(geometry_root)
	_update_right_wall(geometry_root)
	_update_back_wall(geometry_root)
	_update_front_wall(geometry_root)

func _get_room_root() -> Node3D:
	return get_parent() as Node3D

func _get_geometry_root(room_root: Node3D) -> Node3D:
	var geometry_root: Node3D = room_root.get_node_or_null("GeneratedGeometry") as Node3D
	
	if geometry_root == null:
		geometry_root = Node3D.new()
		geometry_root.name = "GeneratedGeometry"
		room_root.add_child(geometry_root)
		geometry_root.owner = get_tree().edited_scene_root
	
	return geometry_root

func _get_or_create_box(parent: Node3D, node_name: String) -> CSGBox3D:
	var box: CSGBox3D = parent.get_node_or_null(node_name) as CSGBox3D
	
	if box == null:
		box = CSGBox3D.new()
		box.name = node_name
		parent.add_child(box)
		box.owner = get_tree().edited_scene_root
	
	return box

func _remove_if_exists(parent: Node3D, node_name: String) -> void:
	var node: Node = parent.get_node_or_null(node_name)
	if node != null:
		node.queue_free()

func _get_y_center() -> float:
	if centered_on_origin:
		return 0.0
	return room_size.y / 2.0

func _update_floor(geometry_root: Node3D) -> void:
	if not generate_floor:
		_remove_if_exists(geometry_root, "Floor")
		return
	
	var box: CSGBox3D = _get_or_create_box(geometry_root, "Floor")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(room_size.x, wall_thickness, room_size.z)
	box.position = Vector3(
		0.0,
		y_center - room_size.y / 2.0 - wall_thickness / 2.0,
		0.0
	)

func _update_ceiling(geometry_root: Node3D) -> void:
	if not generate_ceiling:
		_remove_if_exists(geometry_root, "Ceiling")
		return
	
	var box: CSGBox3D = _get_or_create_box(geometry_root, "Ceiling")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(room_size.x, wall_thickness, room_size.z)
	box.position = Vector3(
		0.0,
		y_center + room_size.y / 2.0 + wall_thickness / 2.0,
		0.0
	)

func _update_left_wall(geometry_root: Node3D) -> void:
	var box: CSGBox3D = _get_or_create_box(geometry_root, "WallLeft")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(wall_thickness, room_size.y, room_size.z)
	box.position = Vector3(
		-room_size.x / 2.0 - wall_thickness / 2.0,
		y_center,
		0.0
	)

func _update_right_wall(geometry_root: Node3D) -> void:
	var box: CSGBox3D = _get_or_create_box(geometry_root, "WallRight")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(wall_thickness, room_size.y, room_size.z)
	box.position = Vector3(
		room_size.x / 2.0 + wall_thickness / 2.0,
		y_center,
		0.0
	)

func _update_back_wall(geometry_root: Node3D) -> void:
	var box: CSGBox3D = _get_or_create_box(geometry_root, "WallBack")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(room_size.x, room_size.y, wall_thickness)
	box.position = Vector3(
		0.0,
		y_center,
		-room_size.z / 2.0 - wall_thickness / 2.0
	)

func _update_front_wall(geometry_root: Node3D) -> void:
	var box: CSGBox3D = _get_or_create_box(geometry_root, "WallFront")
	var y_center: float = _get_y_center()
	
	box.size = Vector3(room_size.x, room_size.y, wall_thickness)
	box.position = Vector3(
		0.0,
		y_center,
		room_size.z / 2.0 + wall_thickness / 2.0
	)
