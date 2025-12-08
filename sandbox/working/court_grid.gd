#@tool
#@icon
#class_name
extends GridContainer
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var cell_size : int
@export var color_gap : float = 0.2
@export var primary_color : Color = Color.SADDLE_BROWN
@export var timer_length : float
## Regular variables
var astar_region : Rect2i
var cells : Array[CourtCell]
var court_cell = preload("uid://b60awjdyd2k5r")
var rows : int
## @onready variables

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	var window_size = get_window().size
	print_debug("This window is this big: %s" % window_size)
	@warning_ignore("integer_division")
	columns = get_window().size.x / cell_size
	if columns % 2 == 0:
		columns -= 1
	@warning_ignore("integer_division")
	rows = get_window().size.y / cell_size
	print_debug("With a cell size of %s, that means there will be %s columns and %s rows\nSo %s cells total" % [cell_size, columns, rows, columns * rows])
	draw_grid()
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func draw_grid():
	@warning_ignore("unused_variable")
	var cell_index : int = 0
	var secondary_color : Color
	var primary_luminance : float = primary_color.get_luminance()
	if primary_luminance >= 0.5:
		secondary_color = primary_color.darkened(color_gap)
	else:
		secondary_color = primary_color.lightened(color_gap)
	for row in rows:
		#print_debug("Starting row %s" % row)
		for column in columns:
			if timer_length:
				await get_tree().create_timer(timer_length).timeout
			#print_debug("Creating a cell at column %s, row %s" % [column, row])
			var cell : CourtCell = court_cell.instantiate()
			cell.custom_minimum_size = Vector2(cell_size, cell_size)
			cell.set("cell_coords", Vector2i(column, row))
			cell.set("cell_index", cell_index)
			if cell_index % 2 == 0:
				cell.color = primary_color
			else:
				cell.color = secondary_color
			add_child(cell)
			cells.append(cell)
			cell_index += 1
	# Draw the AstarGrid
	var astar_grid := AStarGrid2D.new()
	astar_grid.region = Rect2i(
		cells[0].position, Vector2(cell_size * columns, cell_size * rows)
	)
	astar_grid.cell_size = Vector2(cell_size, cell_size)
	astar_grid.update()

## Subclasses
