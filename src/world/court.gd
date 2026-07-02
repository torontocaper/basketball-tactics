#@tool
@icon("uid://dg3f18xvus5g0")
class_name Court
extends Area2D
## The surface a [Match] is played on.

signal court_clicked

var clicked_tile_coords: Vector2i

@onready var court_map: TileMapLayer = %CourtMap
@onready var move_manager: MoveManager = %MoveManager

func _ready() -> void:
	print("Court ready")
	_connect_signals()
	move_manager.court_cells = court_map.get_used_cells()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS
func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx: int):
	if event.is_pressed() and event is InputEventMouseButton:
		print("Court clicked at %s" % get_local_mouse_position())
		clicked_tile_coords = court_map.local_to_map(get_local_mouse_position())
		print("Court clicked at tile %s" % clicked_tile_coords)
		move_manager.selected_cell = clicked_tile_coords
		court_clicked.emit(clicked_tile_coords)
		#queue_redraw()
