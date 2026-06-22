@tool
#@icon(icon_path: String)
class_name TurnManager
extends Node
## Turn controller. Sets initiative/turn order and accesses active player.

signal round_completed

@export var current_index: int = 0:
	set(value):
		current_index = value
		print("TM setting current index to %s" % str(current_index))

## The number representing the current round (a round is when each player has a turn).
@export var current_round: int = 1:
	set(value):
		current_round = value
		print("TM setting current round number to %s" % str(current_round))
		round_completed.emit()

## The number of players on the court in the current game.
@export var players_in_game: Array[Player]:
	set(value):
		players_in_game = value
		print("TM knows there are %s players in the game" % str(players_in_game.size()))

# Core functionality

## Get the [Player] at the current (turn) index
func get_active_player() -> Player:
	print("TM returning player at index %s" % str(current_index))
	var active_player = players_in_game[current_index]
	print("TM says active player is %s" % active_player.name)
	return active_player

## Shuffle [Player]s randomly #TODO implement initiative order based on reaction speed PlayerAttribute
func shuffle_players() -> Array[Player]:
	print("TM shuffling players")
	players_in_game.shuffle()
	return players_in_game

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
