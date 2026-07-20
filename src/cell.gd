class_name Cell
extends Object

var coords: Vector2i
var neighbors: Array[Dictionary]
var distance: int
var path: Array[Cell]:
	get():
		print_debug("Getting the path to cell %s" % coords)
		return path
var is_settled: bool = false:
	set(value):
		is_settled = value
		if is_settled:
			print_debug("Cell %s is now settled" % coords)
