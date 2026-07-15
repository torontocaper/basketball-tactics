#@tool
#@icon(icon_path: String)
class_name Highlighter
extends Line2D
## Documentation comments

#signal
#enum
#const
#@export var
var movement_cost: int
#@onready var
@onready var highlighter_label: Label = $HighlighterLabel
# OVERRIDES

func _ready() -> void:
	print_debug("Highlighter ready")
	highlighter_label.text = str(movement_cost)
