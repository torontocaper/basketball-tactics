#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

const HIGHLIGHTER = preload("uid://8g0gamnv6cvn")

const MOVEMENT_COST_DIAGONAL : int = 3
const MOVEMENT_COST_ORTHOGONAL : int = 2

var all_cells: Array[Vector2i]
#var graph: Dictionary[Vector2i, Array]
var calculated_cells: Dictionary[Vector2i, Dictionary]
var occupied_cells: Dictionary[Vector2i, Player]

@onready var dijkstra: Dijkstra = $Dijkstra

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	all_cells = get_used_cells()
	dijkstra.graph = create_graph(all_cells)

func create_graph(cells: Array[Vector2i]) -> Dictionary[Vector2i, Array]:
	var new_graph : Dictionary[Vector2i, Array]
	for cell in cells:
		var cell_neighbors : Array = get_cell_neighbors(cell)
		new_graph[cell] = cell_neighbors
	return new_graph

func get_cell_neighbors(starting_cell: Vector2i) -> Array[Dictionary]:
	var neighbors : Array[Dictionary] = []
	var orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(starting_cell) 
	var diagonal_neighbors : Array[Vector2i] = get_diagonal_neighbors(starting_cell)
	for o in orthogonal_neighbors:
		if o in all_cells:
			neighbors.append({
				o: MOVEMENT_COST_ORTHOGONAL
			})
	for d in diagonal_neighbors:
		if d in all_cells:
			neighbors.append({
				d: MOVEMENT_COST_DIAGONAL
			})
	return neighbors

func get_diagonal_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_local_position = to_local(player.global_position)
		var player_cell: Vector2i = local_to_map(player_local_position)
		player.current_cell = player_cell
		occupied_cells[player_cell] = player



	# Create the calculated cells dictionary and add all used cells to it
	 #Define a lambda function for updating travel data
	#var lambda = func update_travel_data(coords: Vector2i, starting_cost: int, movement_cost: int):
		#if occupied_cells.has(coords):
			#calculated_cells[coords] = {
				#"cost" = INF,
				#"route" = []
			#}
		#elif calculated_cells.has(coords):
			#if calculated_cells[coords].cost >= starting_cost + movement_cost:
				#calculated_cells[coords].cost = starting_cost + movement_cost
				#calculated_cells[coords].route.append(coords)
		#else:
			#calculated_cells[coords] = {
				#"cost" = starting_cost + movement_cost,
				#"route" = [coords]
			#}
	#var orthogonal_neighbors := get_surrounding_cells(coords) 
	#for neighbor in orthogonal_neighbors:
		#lambda.call(neighbor, calcu, MOVEMENT_COST_ORTHOGONAL)
#
	## Move on to diagonal neighbours
	#var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(cell_to_update)
	#for neighbor in diagonal_neighbors:
		#lambda.call(neighbor, 0, MOVEMENT_COST_DIAGONAL)


	##var cell_to_update = starting_cell
	#while calculated_cells.size() < all_cells.size():
	## Start Dijkstra calculation with immediately surrounding cells
		#var orthogonal_neighbors := get_surrounding_cells(cell_to_update) 
		#for neighbor in orthogonal_neighbors:
			#lambda.call(neighbor, 0, MOVEMENT_COST_ORTHOGONAL)
#
		## Move on to diagonal neighbours
		#var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(cell_to_update)
		#for neighbor in diagonal_neighbors:
			#lambda.call(neighbor, 0, MOVEMENT_COST_DIAGONAL)

func update_travel_data(coords: Vector2i, starting_cost: int, movement_cost: int):
	if occupied_cells.has(coords):
		calculated_cells[coords] = {
			"cost" = INF,
			"route" = []
		}
	elif calculated_cells.has(coords):
		if calculated_cells[coords].cost >= starting_cost + movement_cost:
			calculated_cells[coords].cost = starting_cost + movement_cost
			calculated_cells[coords].route.append(coords)
	else:
		calculated_cells[coords] = {
			"cost" = starting_cost + movement_cost,
			"route" = [coords]
		}
	

	# Go to the next degree of neighbor, starting with orthogonal...
	#for orthogonal_neighbor in orthogonal_neighbors:
		#var next_orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(orthogonal_neighbor)
		#for next_orthogonal_neighbor in next_orthogonal_neighbors:
			#if traversable_cells.has(next_orthogonal_neighbor):
				#if traversable_cells[next_orthogonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL * 2:
					#traversable_cells[next_orthogonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL * 2
					#traversable_cells[next_orthogonal_neighbor].route = [orthogonal_neighbor, next_orthogonal_neighbor]
		#var next_diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(orthogonal_neighbor)
		#for next_diagonal_neighbor in next_diagonal_neighbors:
			#if traversable_cells.has(next_diagonal_neighbor):
				#if traversable_cells[next_diagonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL:
					#traversable_cells[next_diagonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL
					#traversable_cells[next_diagonal_neighbor].route = [orthogonal_neighbor, next_diagonal_neighbor]
	#
	## ...then diagonal
	#for diagonal_neighbor in diagonal_neighbors:
		#var next_orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(diagonal_neighbor)
		#for next_orthogonal_neighbor in next_orthogonal_neighbors:
			#if traversable_cells.has(next_orthogonal_neighbor):
				#if traversable_cells[next_orthogonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL * 2:
					#traversable_cells[next_orthogonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL * 2
					#traversable_cells[next_orthogonal_neighbor].route = [diagonal_neighbor, next_orthogonal_neighbor]
		#var next_diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(diagonal_neighbor)
		#for next_diagonal_neighbor in next_diagonal_neighbors:
			#if traversable_cells.has(next_diagonal_neighbor):
				#if traversable_cells[next_diagonal_neighbor].cost > MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL:
					#traversable_cells[next_diagonal_neighbor].cost = MOVEMENT_COST_ORTHOGONAL + MOVEMENT_COST_DIAGONAL
					#traversable_cells[next_diagonal_neighbor].route = [diagonal_neighbor, next_diagonal_neighbor]
#



	#for cell in traversable_cells.keys():
		#if traversable_cells[cell].cost == INF:
			#traversable_cells.erase(cell)

	#_highlight_calculated_cells(calculated_cells)
	return calculated_cells


#func _highlight_calculated_cells(cells: Dictionary) -> void:
	#for cell in cells:
		#print_debug(cell)
		#var new_highlighter: Highlighter = HIGHLIGHTER.instantiate()
		#new_highlighter.position = map_to_local(cell)
		#new_highlighter.movement_cost = cells[cell].cost
		#add_child(new_highlighter)
