#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## Abstract base class for [CourtLayerData] and [CourtLayerVisual]

signal court_tile_clicked(tile_coords : Vector2i)
signal target_cell_set(target_coords : Vector2i)

var clicked_cell : Vector2i
var target_cell : Vector2i:
	set(value):
		target_cell = value
		target_cell_set.emit(target_cell)
var clicked_cell_data : TileData
var court_cells : Array[Vector2i] ## The cells that are in play.

#region OVERRIDES
func _ready() -> void:
	court_cells = get_used_cells().filter(_is_tile_in_play)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		var click_position : Vector2 = event.position
		event = event as InputEventMouseButton
		if event.button_index == 1:
			clicked_cell = local_to_map(event.position)
			handle_click_at_position(click_position)
		elif event.button_index == 2:
			target_cell = local_to_map(event.position)
#endregion

#region CORE
func handle_click_at_position(click_position) -> void:
	clicked_cell = local_to_map(click_position)
	if not _is_tile_in_play(clicked_cell):
		print_debug("That tile is out of play.")
		return
	else:
		clicked_cell_data = get_cell_tile_data(clicked_cell)
	print_debug("%s registering click at cell %s" % [name, clicked_cell])
#endregion

#region PRIVATE/HELPER
func _is_tile_in_play(tile_coords : Vector2i) -> bool:
	var tile_data : TileData = get_cell_tile_data(tile_coords)
	return tile_data.get_custom_data("is_in_play")
#endregion
