class_name Cell
extends Node2D
## Represents a cell/tile on the [CourtMap]

#region Persistent values unique to this Cell
## Corresponds to the cell's position in the [CourtMap]
var coords: Vector2i:
	set(value):
		coords = value
		name = "CellAt_" + str(coords.x) + "_" + str(coords.y)

## Array of the Cell's immediate neighbors and their distances
var neighbors: Array[Dictionary]

## Player occupying this Cell, if any
var occupying_player: Player:
	set(value):
		occupying_player = value
		print_debug("Cell %s is occupied by %s" % [coords, occupying_player.name])

## Helper var indicating if Cell is occupied
var is_occupied: bool = false:
	get():
		return occupying_player != null
#endregion

@onready var highlighter: Highlighter = $Highlighter

func set_movement_cost(cost: int) -> void:
	highlighter.movement_cost = cost
	highlighter.visible = true

#region Algorithm-dependent values; should be moved
#var distance: int:
	#get():
		##print_stack()
		#return distance
#
#var path: Array[Cell]:
	#get():
		##print_stack()
		#return path
#
#var is_settled: bool = false:
	#set(value):
		##print_stack()
		#is_settled = value
#endregion
