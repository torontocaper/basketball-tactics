#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. Cooredinates between, e.g., MatchManager and UI.

@onready var match_manager: MatchManager = %MatchManager
@onready var scoreboard: Scoreboard = %Scoreboard

# OVERRIDES
func _ready() -> void:
	print_debug("Main ready")
	_connect_signals()
	match_manager.scoreboard = scoreboard

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
