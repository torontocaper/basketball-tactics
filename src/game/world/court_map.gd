#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

#const HIGHLIGHT_POLYGON = preload("uid://djhx0s1dx8ks6")
const MOVEMENT_COST_DIAGONAL : float = 1.5
const MOVEMENT_COST_ORTHOGONAL : float = 1.0

var occupied_cells: Dictionary[Player, Vector2i]:
	set(value):
		occupied_cells = value
		print("There are %s occupied cells" % occupied_cells.size())

var all_cells: Array[Vector2i]

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	all_cells = get_used_cells()

func get_traversable_cells(player: Player, starting_cell: Vector2i, movement_points: float) -> Dictionary:
	print_debug("Getting traversable cells for %s on cell %s with range %s" % [player.name, starting_cell, movement_points])
	var cell_costs: Dictionary[Vector2i, float]
	for cell in all_cells:
		cell_costs[cell] = INF
	#for occupied_cell in occupied_cells.t_:
		#cell_costs.erase(occupied_cell)
	return cell_costs

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_cell: Vector2i = local_to_map(to_local(player.global_position))
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
