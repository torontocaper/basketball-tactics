#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments

#signal
#enum
#const
@export var occupied_cells: Array[Vector2i]:
	set(value):
		occupied_cells = value
		print("There are %s cells occupied" % occupied_cells.size())
#var
#@onready var

# OVERRIDES

func _ready() -> void:
	print_debug("CourtMap ready")
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
