#@tool
#@icon(icon_path: String)
class_name Dijkstra
extends Node
## Documentation comments

#signal
#enum
const MOVEMENT_COST_DIAGONAL : int = 3
const MOVEMENT_COST_ORTHOGONAL : int = 2
#@export var
var cells_in_map: Array[Vector2i]:
	set(value):
		cells_in_map = value
		print_debug("Dijkstra has %s cells" % cells_in_map.size())
#@onready var

# OVERRIDES
func _ready() -> void:
	print_debug("Dijkstra ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

# CORE
func get_traversable_cells(starting_cell: Vector2i, movement_points: int) -> Dictionary:
	
	
	var travel_stats: Dictionary[Vector2i, Dictionary]

	var traversable_cells: Dictionary
	
	for cell in cells_in_map:
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


# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
