#@tool
#@icon(icon_path: String)
class_name TurnManager
extends Node
## Documentation comments

#signal
#enum
#const
#@export var players_on_court: Array[Player]:
	#set(p_o_c):
		#print("Turn Manager knows who's on the court:")
		#players_on_court = p_o_c
		#for player in players_on_court:
			#print(player.name)
#var
#@onready var

# OVERRIDES

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE
func shuffle_players(players: Array[Player]) -> Player:
	print("Turn Manager shuffling players")
	players.shuffle()
	var active_player = players.pop_front()
	return active_player

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
