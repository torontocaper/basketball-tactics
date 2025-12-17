#@tool
#@icon
#class_name
extends CanvasLayer
## Temporary(?) CanvasLayer-derived display for showing info during play


## Signals
## Enums
## Constants
## @export variables
@export var debug_labels: Array[Label]
## Regular variables
## @onready variables

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
#func _ready() -> void:
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func update_ui(debug_info: Array) -> void:
	for item_index in debug_info.size():
		debug_labels[item_index].text = str(debug_info[item_index])
## Subclasses
