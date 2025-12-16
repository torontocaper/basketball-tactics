#@tool
#@icon
#class_name
extends AnimatedSprite2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
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
func move_along_path(path_points:PackedVector2Array) -> void:
	for point in path_points:
		await get_tree().create_timer(0.5).timeout
		print_debug("Translating player by %s pixels" % point)
		position = point
## Remaining methods
## Subclasses
