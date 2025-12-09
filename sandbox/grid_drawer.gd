@tool

extends Node2D

@export var cell_size : int = 128

var columns : int
var rows : int

@onready var window_size := get_window().get_size()

func _ready() -> void:
	queue_redraw()
	
func _draw() -> void:
	@warning_ignore("integer_division")
	columns = window_size.x / cell_size
	if columns % 2 == 0:
		columns -= 1 
	@warning_ignore("integer_division")
	rows = window_size.y / cell_size
	var cell_index : int = 0
	for column in columns:
		for row in rows:
			if cell_index % 2 == 0:
				print_debug("Drawing a dark square at column %s, row %s" % [column, row])
				draw_rect(Rect2(Vector2(column * cell_size, row * cell_size), Vector2(cell_size, cell_size)), Color.DARK_GRAY)
			else:
				print_debug("Drawing a light square at column %s, row %s" % [column, row])
				draw_rect(Rect2(Vector2(column * cell_size, row * cell_size), Vector2(cell_size, cell_size)), Color.LIGHT_GRAY)
			cell_index += 1
