#@tool
#@icon
#class_name
extends AnimatedSprite2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var current_cell: Vector2i
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
func move_along_path(path_points: PackedVector2Array) -> void:
	path_points.remove_at(0) # remove the first element
	for point in path_points:
		await get_tree().create_timer(0.5).timeout
		print_debug("Moving the player to position %s" % point)
		position = point


#func update_current_cell() -> Vector2i:
	
## Remaining methods
## Subclasses
