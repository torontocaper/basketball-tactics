#@tool
#@icon
class_name CourtGrid
extends GridContainer
## UI class that draws a grid for the basketball court.

## Signals
## Enums
## Constants
## @export variables
@export var cell_size : int
@export var color_gap : float = 0.2
@export var line_width : float = 1.0
@export var primary_color : Color = Color.SADDLE_BROWN
@export var timer_length : float
## Regular variables
var astar_grid : AStarGrid2D
var cells : Array[CourtCell]
var court_cell = preload("uid://b60awjdyd2k5r")
var packed_points : PackedVector2Array
var rows : int
var starting_cell := Vector2i.ZERO
var target_cell : Vector2i
## @onready variables

## Overridden built-in virtual methods
func _draw() -> void:
	if packed_points:
		print_debug("Drawing a line with %s points" % packed_points.size())
		draw_polyline(packed_points, Color.WHITE, line_width)
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	var window_size = get_window().size
	print_debug("The window is %s by %s pixels" % [window_size.x, window_size.y])
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
			cell.clicked.connect(on_cell_clicked)
			cells.append(cell)
			cell_index += 1
	# Draw the AstarGrid
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(
		cells[0].position, Vector2(cell_size * columns, cell_size * rows)
	)
	astar_grid.cell_size = Vector2(cell_size, cell_size)
	astar_grid.update()

func draw_path(points_array : Array[Vector2i]) -> void:
	packed_points = PackedVector2Array(points_array)
	queue_redraw()

func on_cell_clicked(cell_coords : Vector2i) -> void:
	print_debug("Grid registers click on cell %s" % cell_coords)
	target_cell = cell_coords
	var astar_path = astar_grid.get_point_path(starting_cell, target_cell)
	draw_path(astar_path)
	print_debug("Found a path between starting cell %s and target cell %s\nIt has %s points" % [starting_cell, target_cell, astar_path.size()])
	starting_cell = target_cell
## Subclasses
