#@tool
@icon("uid://b6h3hpklksw7i")
class_name Team
extends Node2D
## Base class for teams

@export var team_name: String

var players: Array[Player]

var has_ball: bool:
	set(value):
		has_ball = value

var is_active: bool:
	set(value):
		is_active = value
		if is_active:
			for player in players:
				player.select_state = Player.Selectability.SELECTABLE
		else:
			for player in players:
				player.select_state = Player.Selectability.UNSELECTABLE

# OVERRIDES
func _ready() -> void:
	print_debug("%s ready" % team_name)
	_add_players_to_team()

func _add_players_to_team() -> void:
	print_debug("Adding players to %s" % team_name)
	var player_nodes = get_children()
	for node in player_nodes:
		var player = node as Player
		print_debug("Adding %s to %s" % [player.name, team_name])
		players.append(player)
	print_debug("%s has %s players" % [team_name, str(players.size())])
