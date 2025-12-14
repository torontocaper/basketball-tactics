#@tool
#@icon
class_name AstarPath
extends Line2D
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
## Remaining methods
func draw_astar_path(astar_path_points: PackedVector2Array) -> void:
	print_debug("Drawing a path with %s points" % astar_path_points.size())
	points = astar_path_points
## Subclasses
