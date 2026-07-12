#@tool
@icon("uid://dg3f18xvus5g0")
class_name Court
extends Area2D
## The surface a [Game] is played on.

@export var players_on_court: Array[Player]:
	set(value):
		players_on_court = value
		print_debug("There are %s players on the court" % players_on_court.size())

var clicked_tile_coords: Vector2i

@onready var court_map: CourtMap = $CourtMap

func _ready() -> void:
	print_debug("Court ready")
	_connect_signals()

# CORE
func highlight_potential_moves(selected_player: Player) -> void:
	print_debug("Court illustrating potential moves for %s on cell %s" % [selected_player.name, court_map.local_to_map(selected_player.position)])
	print_debug("%s has %s movement points" % [selected_player.name, selected_player.movement_points_per_turn])

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS
func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx: int):
	if event.is_pressed() and event is InputEventMouseButton:
		print_debug("Court clicked at %s" % get_local_mouse_position())
		clicked_tile_coords = court_map.local_to_map(get_local_mouse_position())
		print_debug("Court clicked at tile %s" % clicked_tile_coords)
