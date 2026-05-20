#@tool
#@icon(icon_path: String)
class_name TurnManager
extends Node
## Documentation comments

#signal
#enum
#const
@export var current_index: int = 0:
	set(c_i):
		current_index = c_i
		print("TM setting current index to " + str(current_index))
@export var current_turn: int = 1:
	set(c_t):
		current_turn = c_t
		print("TM setting current turn number to %s" % str(current_turn))
@export var players_in_game: Array[Player]:
	set(p_i_g):
		players_in_game = p_i_g
		print("TM knows there are %s players in the game" % str(players_in_game.size()))
#@onready var

# OVERRIDES

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# CORE
func get_active_player() -> Player:
	print("TM returning player at index %s" % str(current_index))
	var active_player = players_in_game[current_index]
	print("TM says active player is " + active_player.name)
	return active_player


func shuffle_players() -> void:
	print("TM shuffling players")
	players_in_game.shuffle()

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
