#@tool
#@icon
class_name ProtoPlayer2D
extends AnimatedSprite2D
## Documentation comments

## Signals
## Enums
enum State {IDLE, RUN}
## Constants
## @export variables
@export var current_cell: Vector2i
@export_range(1.0, 5.0, 0.5) var speed: float = 2.5

## Regular variables
var current_state: State = State.IDLE
## @onready variables
@onready var player_debug: DebugUI = $PlayerDebug

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
#func _ready() -> void:
	#print_debug("Player starting at global position %s/position %s/cell %s" % [global_position, position, current_cell])
	#await get_tree().create_timer(1.0).timeout
	#print_debug("Player now at global position %s/position %s/cell %s" % [global_position, position, current_cell])

func _process(_delta: float) -> void:
	player_debug.update_ui([current_cell, State.keys()[current_state]])
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
func move_along_path(path_points: PackedVector2Array) -> void:
	play("run")
	path_points.remove_at(0) # remove the first element
	for point in path_points:
		print_debug("Moving the player to position %s" % point)
		var new_tween = create_tween()
		new_tween.tween_property(self, "position", point, 1.0 / speed)
		await new_tween.finished
	play("idle")

#func update_current_cell() -> Vector2i:
	
## Remaining methods
## Subclasses
