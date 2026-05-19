#@tool
#@icon(icon_path: String)
class_name TurnManager
extends Node
## Documentation comments

#signal
#enum
#const
#@export var 
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
	var active_player = players.pop_front() #TODO: add same player to back of array (push_back?)
	return active_player

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
