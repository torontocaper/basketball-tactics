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
func move_along_path(path_array: Array[Dictionary]) -> void:
	current_state = State.RUN
	path_array.remove_at(0) # remove the first element
	for element in path_array:
		print_debug("Moving the player to cell %s (position %s)" % [element.id, element.point])
		var direction_vector = Vector2(element.id - current_cell)
		print_debug("Difference between new cell and old is %s" % direction_vector)
		match direction_vector:
			GlobalDirections.East:
				current_direction = Direction.E
			GlobalDirections.North:
				current_direction = Direction.N
			GlobalDirections.South:
				current_direction = Direction.S
			GlobalDirections.West:
				current_direction = Direction.W
			GlobalDirections.Northeast:
				current_direction = Direction.NE
			GlobalDirections.Northwest:
				current_direction = Direction.NW
			GlobalDirections.Southeast:
				current_direction = Direction.SE
			GlobalDirections.Southwest:
				current_direction = Direction.SW
		var new_tween = create_tween()
		new_tween.tween_property(self, "position", element.point, 1.0 / speed)
		print_debug("Moving in the %s direction" % Direction.keys()[current_direction])
		current_cell = element.id
		await new_tween.finished
	current_state = State.IDLE


## Remaining methods
func set_state(new_state: State) -> void:
	var old_state = current_state
	current_state = new_state
	print_debug("Moving from State %s to State %s" % [State.keys()[old_state], State.keys()[current_state]])
	if current_state == State.IDLE:
		match current_direction:
			Direction.E:
				play("idle_E")
			_:
				play("idle_SE")
	elif current_state == State.RUN:
		match current_direction:
			Direction.E:
				play("run_E")
			_:
				play("run_SE")
## Subclasses
