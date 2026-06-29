#@tool
#@icon(icon_path: String)
#class_name SignalBus
extends Node
## Class for routing signals.

#signal
#enum
#const
#@export var
#var
#@onready var

# OVERRIDES

func _ready() -> void:
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
