#@tool
#@icon
class_name CourtCell
extends ColorRect
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
var cell_coords : Vector2i
var cell_index : int
## @onready variables
@onready var coords_label: Label = $CoordsLabel
## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	coords_label.text = str(cell_coords)
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
## Subclasses

func _on_mouse_entered() -> void:
	#print_debug("You've hovered on cell %s" % cell_coords)
	pass
