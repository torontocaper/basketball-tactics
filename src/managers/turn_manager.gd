#@tool
@icon("uid://hb3h3lrd8n4x")
class_name TurnManager
extends Node
### Turn controller.

enum TeamTurn {HOME, AWAY}

var current_turn: TeamTurn:
	set(value):
		current_turn = value

func _ready() -> void:
	print_debug("TurnManager ready")
