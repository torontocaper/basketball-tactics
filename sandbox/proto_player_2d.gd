#@tool
#@icon
class_name ProtoPlayer2D
extends AnimatedSprite2D
## Documentation comments

## Signals
## Enums
enum Direction {N, E, S, W, NE, NW, SE, SW}
enum State {IDLE, RUN}
## Constants
## @export variables
@export var current_cell: Vector2i
@export_range(1.0, 5.0, 0.5) var speed: float = 2.5

## Regular variables
var current_direction: Direction = Direction.SE
var current_state: State = State.IDLE: set = set_state
## @onready variables
@onready var player_debug: DebugUI = $PlayerDebug

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
#func _ready() -> void:

func _process(_delta: float) -> void:
	player_debug.update_ui([current_cell, State.keys()[current_state], Direction.keys()[current_direction]])


#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
func move_along_path(path_points: PackedVector2Array) -> void:
	current_state = State.RUN
	path_points.remove_at(0) # remove the first element
	for point in path_points:
		print_debug("Moving the player to position %s" % point)
		var new_tween = create_tween()
		new_tween.tween_property(self, "position", point, 1.0 / speed)
		await new_tween.finished
	current_state = State.IDLE


## Remaining methods
func set_state(new_state: State) -> void:
	var old_state = current_state
	current_state = new_state
	print_debug("Moving from State %s to State %s" % [State.keys()[old_state], State.keys()[current_state]])
	if current_state == State.IDLE:
		play("idle_SE")
	elif current_state == State.RUN:
		play("run_SE")
## Subclasses
