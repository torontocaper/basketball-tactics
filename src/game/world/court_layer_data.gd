#@tool
#@icon(icon_path: String)
class_name CourtLayerData
extends CourtLayer
## The layer of the court responsible for data -- point values, player positions, etc. 

signal court_tile_clicked(tile_coords : Vector2i)

const MOVEMENT_COST_ORTHOGONAL : int = 2
const MOVEMENT_COST_DIAGONAL : int = 3

var dijkstra_graph : Dictionary[Vector2i, Dictionary] ## Dictionary of cells and their immediate neighbors, along with the movement cost for each neighbor. Sent to [MoveManager] for pathfinding.

#region OVERRIDES
func _ready() -> void:
	super()
	court_tile_clicked.connect(MoveManager.handle_click)
	for cell in court_cells:
		var cell_neighbors : Dictionary[Vector2i, int] = get_cell_neighbors(cell)
		dijkstra_graph[cell] = cell_neighbors
	MoveManager.graph = dijkstra_graph

func handle_click_at_position(click_position: Vector2) -> void:
	super(click_position)
	if _is_tile_in_play(clicked_cell):
		var tile_territory : String = clicked_cell_data.get_custom_data("team_territory")
		var tile_points : int = clicked_cell_data.get_custom_data("points")
		var tile_column : String = clicked_cell_data.get_custom_data("column")
		var tile_row : String = clicked_cell_data.get_custom_data("row")
		var tile_chess_notation : String = tile_territory[0] + tile_column + tile_row
		print_debug("You clicked tile %s. Shots from here are worth %s points." % [tile_chess_notation, tile_points])
		court_tile_clicked.emit(clicked_cell)
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
