#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## Abstract base class for [CourtLayerData] and [CourtLayerVisual]

#signal
#enum
#const
#@export var
var clicked_cell : Vector2i
var clicked_cell_data : TileData
#@onready var

#region OVERRIDES
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

#region RECEIVERS
#endregion
