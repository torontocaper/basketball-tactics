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
## Regular variables
var current_state: State = State.IDLE
## @onready variables
@onready var player_debug: DebugUI = $PlayerDebug

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	print_debug("Player starting on cell %s" % current_cell)
	await get_tree().create_timer(1.0).timeout
	print_debug("Player now on cell %s" % current_cell)
	

func _process(_delta: float) -> void:
	player_debug.update_ui([current_cell, State.keys()[current_state]])
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
