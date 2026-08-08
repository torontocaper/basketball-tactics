#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## Base class for [CourtLayerData] and [CourtLayerVisual]

signal court_cell_clicked(cell_coords : Vector2i) ## Emitted when a cell on the [Court] is clicked.
signal source_cell_set(source_cell_coords : Vector2i) ## Emitted when [member source_cell] is set.
signal target_cell_set(target_cell_coords : Vector2i) ## Emitted when [member target_cell] is set.

var clicked_cell : Vector2i ## The coordinates of the cell that was most recently clicked.
var clicked_cell_data : TileData ## The [TileData] associated with the [member clicked_cell].
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
	if event.is_pressed() and event is InputEventMouseButton:
		var click_position : Vector2 = event.position
		event = event as InputEventMouseButton
		var is_right_click : bool
		if event.button_index == 1:
			is_right_click = false
			clicked_cell = local_to_map(event.position)
		elif event.button_index == 2: #TODO: change this to a context-dependent left-click/touch input for mobile devices
			is_right_click = true
			target_cell = local_to_map(event.position)
		handle_click_at_position(click_position, is_right_click)
#endregion

#region CORE
func handle_click_at_position(click_position : Vector2, is_right_click : bool) -> void:
	clicked_cell = local_to_map(click_position)
	if not _is_cell_in_play(clicked_cell):
		print_debug("That cell is out of play.")
		return
	clicked_cell_data = get_cell_tile_data(clicked_cell)
	if is_right_click:
		target_cell = clicked_cell
	else:
		source_cell = clicked_cell
#endregion

#region PRIVATE/HELPER
func _is_cell_in_play(cell_coords : Vector2i) -> bool:
	var tile_data : TileData = get_cell_tile_data(cell_coords)
	return tile_data.get_custom_data("is_in_play")
#endregion
