#@tool
#@icon(icon_path: String)
class_name CourtLayerData
extends TileMapLayer
## The layer of the court responsible for data -- point values, player positions, etc. 

signal court_tile_clicked(tile_coords : Vector2i)

const MOVEMENT_COST_ORTHOGONAL : int = 2
const MOVEMENT_COST_DIAGONAL : int = 3

var court_cells : Array[Vector2i] ## The cells that are in play.
var dijkstra_graph : Dictionary[Vector2i, Dictionary] ## Dictionary of cells and their immediate neighbors, along with the movement cost for each neighbor. 

#region OVERRIDES
func _ready() -> void:
	court_tile_clicked.connect(MoveManager.handle_click)
	court_cells = get_used_cells().filter(is_tile_in_play)
	for cell in court_cells:
		var cell_neighbors : Dictionary[Vector2i, int] = get_cell_neighbors(cell)
		dijkstra_graph[cell] = cell_neighbors
	MoveManager.graph = dijkstra_graph

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		var click_position : Vector2 = event.position
		var click_coords = local_to_map(click_position)
		handle_click(click_coords)
#endregion

#region CORE
## Assign neighbors to each cell. Best handled here rather than in MoveManager.
#func create_node(cell_coords: Vector2i) -> Dictionary[Vector2i, Dictionary]:
	#var node_neighbors : Dictionary[Vector2i, int] = get_cell_neighbors(cell_coords)
	#var new_node : Dictionary[Vector2i, Dictionary] = {
		#cell_coords: node_neighbors
	#}
	#return new_node

## For each cell in the graph, find its immediate neighbors and assign travel distances to each. 
## We can't do this in `set_cell_coords` because not all neighbors have been added to the tree yet.
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

func handle_click(click_coords: Vector2i) -> void:
	var tile_data = get_cell_tile_data(click_coords)
	if not is_tile_in_play(click_coords):
		print_debug("That tile is out of play.")
	else:
		var tile_territory : String = tile_data.get_custom_data("team_territory")
		var tile_points : int = tile_data.get_custom_data("points")
		var tile_column : String = tile_data.get_custom_data("column")
		var tile_row : String = tile_data.get_custom_data("row")
		var tile_chess_notation : String = tile_territory[0] + tile_column + tile_row
		print_debug("You clicked tile %s. Shots from here are worth %s points." % [tile_chess_notation, tile_points])
		court_tile_clicked.emit(click_coords)

func is_tile_in_play(tile_coords : Vector2i) -> bool:
	return get_cell_tile_data(tile_coords).get_custom_data("is_in_play")

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
