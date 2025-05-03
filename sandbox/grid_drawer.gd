@tool

extends Node2D

var columns : int
var rows : int
var dark_square : bool = true

@onready var window_size := get_window().get_size()

func _draw() -> void:
	columns = window_size.x / 128
	rows = window_size.y / 128
	for column in columns:
		for row in rows:
			if dark_square:
				draw_rect(Rect2(Vector2(column * 128, row * 128), Vector2(128, 128)), Color.DARK_GRAY)
				dark_square = false
			else:
				draw_rect(Rect2(Vector2(column * 128, row * 128), Vector2(128, 128)), Color.LIGHT_GRAY)
				dark_square = true
			draw_string(ThemeDB.fallback_font, Vector2(column * 128 + 4, row * 128 + 16), str(column) + "," + str(row))
