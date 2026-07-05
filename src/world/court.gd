#@tool
@icon("uid://dg3f18xvus5g0")
class_name Court
extends Area2D
## The surface a [Match] is played on.

var clicked_tile_coords: Vector2i

@onready var court_map: TileMapLayer = %CourtMap
#@onready var move_manager: MoveManager = %MoveManager

func _ready() -> void:
	print_debug("Court ready")
	_connect_signals()
	#move_manager.court_cells = court_map.get_used_cells()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE
func highlight_potential_moves(selected_player: Player) -> void:
	print_debug("Court illustrating potential moves for %s on cell %s" % [selected_player.name, court_map.local_to_map(selected_player.position)])
	print_debug("Player has %s movement points" % selected_player.movement_points_per_turn)

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS
func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx: int):
	if event.is_pressed() and event is InputEventMouseButton:
		print_debug("Court clicked at %s" % get_local_mouse_position())
		clicked_tile_coords = court_map.local_to_map(get_local_mouse_position())
		print_debug("Court clicked at tile %s" % clicked_tile_coords)
		#move_manager.selected_cell = clicked_tile_coords
		#court_clicked.emit(clicked_tile_coords)
		#print_debug("Clicked tile bottom-right corner = " + str(court_map.get_neighbor_cell(clicked_tile_coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)))
