#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

#signal
#enum
#const
@export var occupied_cells: Array[Vector2i]
#var
#@onready var

# OVERRIDES

func _ready() -> void:
	print_debug("%s ready" % name)
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
