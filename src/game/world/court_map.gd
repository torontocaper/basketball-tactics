#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

@export var occupied_cells: Array[Dictionary]:
	set(value):
		occupied_cells = value
		print("There are %s cells occupied" % occupied_cells.size())

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())

func print_player_cells(players: Array[Player]) -> void:
	for player in players:
		print_debug("%s on cell %s" % [player.name, local_to_map(to_local(player.global_position))])

func set_occupied_cells(players: Array[Player]) -> void:
	for player in players:
		var player_cell: Vector2i = local_to_map(to_local(player.global_position))
		player.current_cell = player_cell
		occupied_cells.append({
			"player": player,
			"cell": player_cell
		})
