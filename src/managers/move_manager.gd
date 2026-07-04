#@tool
@icon("uid://bfdiav77fq1x")
class_name MoveManager
extends Node
## Documentation comments

#signal
enum NeighbourType {
	ORTHOGONAL,
	DIAGONAL
}

enum NeighbourDirection {
	NORTH,
	NORTHEAST,
	EAST,
	SOUTHEAST,
	SOUTH,
	SOUTHWEST,
	WEST,
	NORTHWEST
}

const MOVEMENT_COST_ORTHOGONAL: float = 1.0
const MOVEMENT_COST_DIAGONAL: float= 1.5
const TILE_SIZE: Vector2 = Vector2(48.0, 48.0)

@export var court_cells: Array[Vector2i]:
	set(value):
		court_cells = value
		print_debug("MoveManager has a list of %s court cells" % court_cells.size())

@export var selected_cell: Vector2i:
	set(value):
		selected_cell = value
		print_debug("MoveManager analysing cell %s" % selected_cell)
		_move_selection_indicator(selected_cell)
		var selected_cell_neighbours = get_neighbours(selected_cell)
		print_debug("This cell's neighbours: %s" % str(selected_cell_neighbours))

@onready var selection_indicator: Polygon2D = %SelectionIndicator

# OVERRIDES

func _ready() -> void:
	print_debug("%s ready" % name)
	_connect_signals()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE
func get_neighbours(cell: Vector2i) -> Dictionary:
	var neighbours: Dictionary = {}
	if cell not in court_cells:
		print_debug("Not a valid cell")
	else:
		neighbours["east"] = cell + Vector2i.RIGHT
		neighbours["southeast"] = cell + (Vector2i.RIGHT + Vector2i.DOWN)
		neighbours["south"] = cell + Vector2i.DOWN
		neighbours["southwest"] = cell + (Vector2i.DOWN + Vector2i.LEFT)
		neighbours["west"] = cell + Vector2i.LEFT
		neighbours["northwest"] = cell + (Vector2i.LEFT + Vector2i.UP)
		neighbours["north"] = cell + Vector2i.UP
		neighbours["northeast"] = cell + (Vector2i.RIGHT + Vector2i.UP)
	return neighbours

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

func _move_selection_indicator(new_position: Vector2) -> void:
	selection_indicator.position = new_position * TILE_SIZE

# RECEIVERS
