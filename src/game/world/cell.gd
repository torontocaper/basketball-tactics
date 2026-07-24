class_name Cell
extends Sprite2D
## Represents a cell/tile on the [CourtMap]

## Persistent values unique to this Cell
var alpha_coords: String
var coords: Vector2i ## Corresponds to the cell's position in the [CourtMap]
var neighbors: Array[Dictionary]
var is_occupied: bool = false:
	get():
		return occupying_player != null
var occupying_player: Player:
	set(value):
		occupying_player = value
		print_debug("Cell %s is occupied by %s" % [coords, occupying_player.name])

## Algorithm-dependent values; should be moved
var distance: int:
	get():
		#print_stack()
		return distance

var path: Array[Cell]:
	get():
		#print_stack()
		return path

var is_settled: bool = false:
	set(value):
		#print_stack()
		is_settled = value
