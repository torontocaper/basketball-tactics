#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

const MOVEMENT_COST_DIAGONAL : int = 3
const MOVEMENT_COST_ORTHOGONAL : int = 2

var all_cells: Array[Vector2i]
var occupied_cells: Dictionary[Player, Vector2i]

#@onready var dijkstra: Dijkstra = $Dijkstra

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	all_cells = get_used_cells()


func get_traversable_cells(player: Player, starting_cell: Vector2i, movement_points: int) -> Dictionary:
	var travel_stats: Dictionary[Vector2i, Dictionary]
	var traversable_cells: Dictionary
	
	for cell in all_cells:
		travel_stats[cell] = {
			"cost" = INF,
			"route" = []
		}

	# Remove occupied cells from travel stat calculation
	for occupied_cell in occupied_cells:
		var cell_to_remove = occupied_cells.get(occupied_cell)
		print_debug("removing %s from traversable cells" % cell_to_remove)
		travel_stats.erase(cell_to_remove)

	# Start Dijkstra calculation with immediately surrounding cells
	var orthogonal_neighbors := get_surrounding_cells(starting_cell) 
	for neighbor in orthogonal_neighbors:
		if travel_stats.has(neighbor):
			travel_stats[neighbor].cost = MOVEMENT_COST_ORTHOGONAL
			travel_stats[neighbor].route.append(neighbor)
			traversable_cells.get_or_add(travel_stats[neighbor])

	# Move on to diagonal neighbours (this may require a helper function)
	var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(starting_cell)
	for neighbor in diagonal_neighbors:
		if travel_stats.has(neighbor):
			travel_stats[neighbor].cost = MOVEMENT_COST_DIAGONAL
			travel_stats[neighbor].route.append(neighbor)
			traversable_cells.get_or_add(travel_stats[neighbor])

	return traversable_cells

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_local_position = to_local(player.global_position)
		var player_cell: Vector2i = local_to_map(player_local_position)
		player.current_cell = player_cell
		occupied_cells[player] = player_cell

func _get_diagonal_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
	]
	return diagonal_neighbors
#func highlight_cell(cell: Vector2i) -> void:
	#var polygon_node: Polygon2D = HIGHLIGHT_POLYGON.instantiate()
	#polygon_node.position = map_to_local(cell)
	#add_child(polygon_node)

#func highlight_movable_cells(player: Player, starting_cell: Vector2i, movement_range: float) -> void:
	#print_debug("Highlighting movable cells for %s on cell %s with range %s" % [player.name, starting_cell, movement_range])
	#var neighbors = [
		#get_neighbor_cell(starting_cell, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER),
		#get_neighbor_cell(starting_cell, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		#get_neighbor_cell(starting_cell, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		#get_neighbor_cell(starting_cell, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER)
		#]
	#for neighbor in neighbors:
		#highlight_cell(neighbor)
#
#func print_player_cells(players: Array[Player]) -> void:
	#for player in players:
		#print_debug("%s on cell %s" % [player.name, local_to_map(to_local(player.global_position))])
