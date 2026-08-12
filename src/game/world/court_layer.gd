#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## Base class for [CourtLayerData] and [CourtLayerVisual]

signal source_cell_set(source_cell_coords : Vector2i) ## Emitted when [member source_cell] is set.
signal target_cell_set(target_cell_coords : Vector2i) ## Emitted when [member target_cell] is set.

var court_cells : Array[Vector2i] ## The cells that are in play.
var source_cell : Vector2i: ## The source/starting cell for movement calculations
	set(value):
		source_cell = value
		source_cell_set.emit(source_cell)
var target_cell : Vector2i: ## The target/destination cell for movement calculations.
	set(value):
		target_cell = value
		target_cell_set.emit(target_cell)

#region OVERRIDES
func _ready() -> void:
	court_cells = get_used_cells().filter(_is_cell_in_play)

func _unhandled_input(event: InputEvent) -> void:
	#TODO i don't think this should be handled here
	if event.is_pressed() and event is InputEventMouseButton:
		event = event as InputEventMouseButton
		var click_position : Vector2 = event.position
		var clicked_cell = local_to_map(click_position)
		if clicked_cell not in court_cells:
			return
		var is_right_click : bool
		if event.button_index == 1:
			is_right_click = false
			source_cell = clicked_cell
		elif event.button_index == 2: #TODO: change this to a context-dependent left-click/touch input for mobile devices
			is_right_click = true
			target_cell = clicked_cell
		handle_click_at_cell(clicked_cell, is_right_click)
#endregion

#region CORE
func handle_click_at_cell(_clicked_cell : Vector2i, _is_right_click : bool) -> void:
	pass
#endregion

#region PRIVATE/HELPER
func _is_cell_in_play(cell_coords : Vector2i) -> bool:
	var tile_data : TileData = get_cell_tile_data(cell_coords)
	return tile_data.get_custom_data("is_in_play")
#endregion
