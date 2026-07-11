#@tool
@icon("uid://b6h3hpklksw7i")
class_name Team
extends Node2D
## Base class for teams

@export var players: Array[Player]
@export var team_name: String

# OVERRIDES

func _ready() -> void:
	print_debug("%s ready" % team_name)
	_add_players_to_team()

func _add_players_to_team() -> void:
	print_debug("Adding players to %s" % team_name)
	var player_nodes = get_children()
	for node in player_nodes:
		var player = node as Player
		players.append(player)
	print_debug("%s has %s players" % [team_name, str(players.size())])
