class_name Cell
extends Node2D

var coords: Vector2i

var neighbors: Array[Dictionary]

var distance: int

var occupying_player: Player:
	set(value):
		occupying_player = value
		print_debug("Cell %s is occupied by %s" % [coords, occupying_player.name])

var path: Array[Cell]:
	get():
		return path

var is_occupied: bool = false:
	set(value):
		is_occupied = value
		if is_occupied:
			print_debug("Cell %s is occupied" % coords)

var is_reachable: bool

var is_settled: bool = false:
	set(value):
		is_settled = value

func mark_cell_as_occupied(occupier: Player) -> void:
	is_occupied = true
	occupying_player = occupier
