#@tool
@icon("uid://b6h3hpklksw7i")
class_name Team
extends Node2D
## Base class for teams

var players: Array[Player]

var has_ball: bool:
	set(value):
		has_ball = value

var is_active: bool:
	set(value):
		is_active = value
		for player in players:
			if is_active:
					player.player_state = Player.PlayerState.SELECTABLE
			else:
					player.player_state = Player.PlayerState.UNSELECTABLE

# OVERRIDES
func _ready() -> void:
	players = _get_players()

func _get_players() -> Array[Player]:
	var player_array : Array[Player]
	var player_nodes = get_children()
	for node in player_nodes:
		var player = node as Player
		player_array.append(player)
		player.team = self
	return player_array
