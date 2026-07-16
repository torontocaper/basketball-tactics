#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

const HIGHLIGHTER = preload("uid://8g0gamnv6cvn")

const MOVEMENT_COST_DIAGONAL : int = 3
const MOVEMENT_COST_ORTHOGONAL : int = 2

var all_cells: Array[Vector2i]
var occupied_cells: Dictionary[Vector2i, Player]

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	all_cells = get_used_cells()

func get_traversable_cells(_player: Player, starting_cell: Vector2i, _movement_points: int) -> Dictionary:
	var traversable_cells: Dictionary[Vector2i, Dictionary]
	
	for cell in all_cells:
		traversable_cells[cell] = {
			"cost" = INF,
			"route" = []
		}

	# Remove occupied cells from traversable cells
	for occupied_cell in occupied_cells:
		print_debug("removing %s from traversable cells" % occupied_cell)
		traversable_cells.erase(occupied_cell)

	# Start Dijkstra calculation with immediately surrounding cells
	var orthogonal_neighbors := get_surrounding_cells(starting_cell) 
	for neighbor in orthogonal_neighbors:
		if traversable_cells.has(neighbor):
			traversable_cells[neighbor].cost = MOVEMENT_COST_ORTHOGONAL
			traversable_cells[neighbor].route.append(neighbor)

	# Move on to diagonal neighbours
	var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(starting_cell)
	for neighbor in diagonal_neighbors:
		if traversable_cells.has(neighbor):
			traversable_cells[neighbor].cost = MOVEMENT_COST_DIAGONAL
			traversable_cells[neighbor].route.append(neighbor)
	
	# Go to the next degree of neighbor, starting with orthogonal...
	for orthogonal_neighbor in orthogonal_neighbors:
		var next_orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(orthogonal_neighbor)
		for next_orthogonal_neighbor in next_orthogonal_neighbors:
			if traversable_cells.has(next_orthogonal_neighbor):
				if traversable_cells[next_orthogonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL * 2:
					traversable_cells[next_orthogonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL * 2
					traversable_cells[next_orthogonal_neighbor].route = [orthogonal_neighbor, next_orthogonal_neighbor]
		var next_diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(orthogonal_neighbor)
		for next_diagonal_neighbor in next_diagonal_neighbors:
			if traversable_cells.has(next_diagonal_neighbor):
				if traversable_cells[next_diagonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL:
					traversable_cells[next_diagonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL
					traversable_cells[next_diagonal_neighbor].route = [orthogonal_neighbor, next_diagonal_neighbor]
	
	# ...then diagonal
	for diagonal_neighbor in diagonal_neighbors:
		var next_orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(diagonal_neighbor)
		for next_orthogonal_neighbor in next_orthogonal_neighbors:
			if traversable_cells.has(next_orthogonal_neighbor):
				if traversable_cells[next_orthogonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL * 2:
					traversable_cells[next_orthogonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL * 2
					traversable_cells[next_orthogonal_neighbor].route = [diagonal_neighbor, next_orthogonal_neighbor]
		var next_diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(diagonal_neighbor)
		for next_diagonal_neighbor in next_diagonal_neighbors:
			if traversable_cells.has(next_diagonal_neighbor):
				if traversable_cells[next_diagonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL:
					traversable_cells[next_diagonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL
					traversable_cells[next_diagonal_neighbor].route = [diagonal_neighbor, next_diagonal_neighbor]

	for cell in traversable_cells.keys():
		if traversable_cells[cell].cost == INF:
			traversable_cells.erase(cell)

	_highlight_traversable_cells(traversable_cells)
	return traversable_cells

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_local_position = to_local(player.global_position)
		var player_cell: Vector2i = local_to_map(player_local_position)
		player.current_cell = player_cell
		occupied_cells[player_cell] = player

func _get_diagonal_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
	]
	return diagonal_neighbors

func _highlight_traversable_cells(cells: Dictionary) -> void:
	for cell in cells:
		print_debug(cell)
		var new_highlighter: Highlighter = HIGHLIGHTER.instantiate()
		new_highlighter.position = map_to_local(cell)
		new_highlighter.movement_cost = cells[cell].cost
		add_child(new_highlighter)
