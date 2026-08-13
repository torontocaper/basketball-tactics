#@tool
#@icon(icon_path: String)
class_name CourtLayerData
extends CourtLayer
## The layer of the court responsible for data -- point values, player positions, etc. 

const MOVEMENT_COST_ORTHOGONAL : int = 2
const MOVEMENT_COST_DIAGONAL : int = 3

var dijkstra_graph : Dictionary[Vector2i, Dictionary] ## Dictionary of cells and their immediate neighbors, along with the movement cost for each neighbor. Sent to [MoveManager] for pathfinding.

#region OVERRIDES
func _ready() -> void:
	super()
	TurnManager.connect("player_selected", set_source_cell)
	connect("source_cell_set", MoveManager.update_map)
	connect("target_cell_set", MoveManager.get_path_by_coords)
	for cell in court_cells:
		var cell_neighbors : Dictionary[Vector2i, int] = get_cell_neighbors(cell)
		dijkstra_graph[cell] = cell_neighbors
	MoveManager.graph = dijkstra_graph

func handle_click_at_cell(clicked_cell : Vector2i, _is_right_click : bool) -> void:
	var clicked_cell_data = get_cell_tile_data(clicked_cell)
	var cell_territory : String = clicked_cell_data.get_custom_data("team_territory")
	var cell_points : int = clicked_cell_data.get_custom_data("points")
	var cell_column : String = clicked_cell_data.get_custom_data("column")
	var cell_row : String = clicked_cell_data.get_custom_data("row")
	var cell_chess_notation : String = cell_territory[0] + cell_column + cell_row
	print_debug("You clicked cell %s. Shots from here are worth %s points." % [cell_chess_notation, cell_points])
#endregion

#region CORE
## For each cell in the graph, find its immediate neighbors and assign travel distances to each. 
func get_cell_neighbors(cell_coords: Vector2i) -> Dictionary[Vector2i, int]:
	var new_neighbors : Dictionary[Vector2i, int] = {}
	var orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(cell_coords) 
	var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(cell_coords)
	for o in orthogonal_neighbors:
		if o in court_cells:
			new_neighbors[o] = MOVEMENT_COST_ORTHOGONAL
	for d in diagonal_neighbors:
		if d in court_cells:
			new_neighbors[d] = MOVEMENT_COST_DIAGONAL
	return new_neighbors

func set_source_cell(source_player_coords : Vector2i) -> void:
	print_debug("Setting source cell at %s" % source_player_coords)
	source_cell = source_player_coords
#endregion

#region PRIVATE/HELPER
## Get the coordinates for the diagonal neighbors of the [Cell] at `cell_coords`.
func _get_diagonal_neighbors(cell_coords: Vector2i) -> Array[Vector2i]: 
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors
#endregion

#region RECEIVERS
#endregion

#region INNER_CLASSES
#endregion
