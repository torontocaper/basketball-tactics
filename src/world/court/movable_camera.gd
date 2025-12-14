#@tool
#@icon
class_name MovableCamera
extends Camera2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
## @onready variables
var mouse_position : Vector2

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
#func _ready() -> void:
func _process(_delta: float) -> void:
	mouse_position = get_global_mouse_position()
	move_to(mouse_position)
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func move_to(target : Vector2) -> void:
	position = target
## Subclasses
