#@tool
@icon("uid://b6h3hpklksw7i")
class_name Team
extends Node2D
## Base class for teams

#signal
#enum
#const
@export var players: Array[Player]
@export var team_logo: Texture2D
@export var team_name: String
@export var team_name_short: String
#var
#@onready var

# OVERRIDES

func _ready() -> void:
	print_debug("Team ready")
	_connect_signals()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
