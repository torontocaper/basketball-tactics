#@tool
@icon("uid://dg3f18xvus5g0")
class_name Court
extends Area2D
## The surface a [Match] is played on.

signal court_clicked
#enum
#const
#@export var
var cells: Array[Vector2i]
var clicked_tile_coords:= Vector2i(-1, -1)
#@onready var
@onready var court_map: TileMapLayer = %CourtMap

func _draw() -> void:
	if not clicked_tile_coords == Vector2i(-1, -1):
		var clicked_rect_size:= Vector2(court_map.tile_set.tile_size)
		var clicked_rect_offset:= clicked_rect_size / 2.0
		var clicked_rect_position:= court_map.map_to_local(clicked_tile_coords) - clicked_rect_offset
		var clicked_rect:= Rect2(clicked_rect_position, clicked_rect_size)
		draw_rect(clicked_rect, Color(Color.AQUA, 0.5), true)

func _ready() -> void:
	_connect_signals()
	cells = court_map.get_used_cells()

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
		court_clicked.emit(clicked_tile_coords)
		queue_redraw()
