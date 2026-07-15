#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

#const HIGHLIGHT_POLYGON = preload("uid://djhx0s1dx8ks6")
const MOVEMENT_COST_DIAGONAL : float = 1.5
const MOVEMENT_COST_ORTHOGONAL : float = 1.0

var all_cells: Array[Vector2i]
var occupied_cells: Dictionary[Player, Vector2i]

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	all_cells = get_used_cells()

func get_traversable_cells(player: Player, starting_cell: Vector2i, movement_points: float) -> Dictionary:
	
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
	var surrounding_cells:= get_surrounding_cells(starting_cell) 
	for surrounding_cell in surrounding_cells:
		if travel_stats.has(surrounding_cell):
			travel_stats[surrounding_cell].cost = MOVEMENT_COST_ORTHOGONAL
			travel_stats[surrounding_cell].route.append(surrounding_cell)
			traversable_cells.get_or_add(travel_stats[surrounding_cell])

	return traversable_cells

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_local_position = to_local(player.global_position)
		var player_cell: Vector2i = local_to_map(player_local_position)
		player.current_cell = player_cell
		occupied_cells[player] = player_cell

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
