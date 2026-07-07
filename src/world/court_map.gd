#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## Documentation comments


@export var occupied_cells: Array[Vector2i]:
	set(value):
		occupied_cells = value
		print("There are %s cells occupied" % occupied_cells.size())

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
