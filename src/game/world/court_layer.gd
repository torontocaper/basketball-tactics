#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## Base class for [CourtLayerData] and [CourtLayerVisual]

var court_cells : Array[Vector2i] ## The cells that are in play.

#region OVERRIDES
func _ready() -> void:
	court_cells = get_used_cells().filter(_is_cell_in_play)
#endregion

#region PRIVATE/HELPER
func _is_cell_in_play(cell_coords : Vector2i) -> bool:
	var tile_data : TileData = get_cell_tile_data(cell_coords)
	return tile_data.get_custom_data("is_in_play")
#endregion
