#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

#signal
#enum
#const
#@export var
#var
#@onready var
@onready var scoreboard: Scoreboard = $Scoreboard

# OVERRIDES

func _ready() -> void:
	print_debug("%s ready at %s ms" % [name, Time.get_ticks_msec()])
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
