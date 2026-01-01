#@tool
#@icon
class_name Player
extends AnimatedSprite2D
## Documentation comments

## Signals

## Enums
enum Direction {N, NE, E, SE, S, SW, W, NW}
enum State {IDLE, RUN}

## Constants

## @export variables
@export_range(1.0, 5.0, 0.5) var speed: float = 2.5

## Regular variables
var current_cell: Vector2i
var current_direction: Direction = Direction.E: set = set_direction
var current_state: State = State.IDLE: set = set_state

## @onready variables
@onready var player_debug: DebugUI = $PlayerDebug

## Overridden built-in virtual methods

func _ready() -> void:
	print_debug("Player %s ready" % self.name)

func _process(_delta: float) -> void:
	player_debug.update_ui([current_cell, State.keys()[current_state], Direction.keys()[current_direction]])


func move_along_path(path_array: Array[Dictionary]) -> void:
	path_array.remove_at(0) # remove the first element
	for element in path_array:
		var direction_vector = Vector2(element.id - current_cell)
		match direction_vector:
			GlobalDirections.N:
				current_direction = Direction.N
			GlobalDirections.NE:
				current_direction = Direction.NE
			GlobalDirections.E:
				current_direction = Direction.E
			GlobalDirections.SE:
				current_direction = Direction.SE
			GlobalDirections.S:
				current_direction = Direction.S
			GlobalDirections.SW:
				current_direction = Direction.SW
			GlobalDirections.W:
				current_direction = Direction.W
			GlobalDirections.NW:
				current_direction = Direction.NW
		current_state = State.RUN ## TODO: Not sure this belongs here; create separate 'setter' for direction, and run set_state within that?
		var new_tween = create_tween()
		new_tween.tween_property(self, "position", element.point, 1.0 / speed)
		print_debug("Moving in the %s direction" % Direction.keys()[current_direction])
		current_cell = element.id
		await new_tween.finished
	current_state = State.IDLE

func set_direction(new_direction: Direction) -> void:
	var old_direction := current_direction
	current_direction = new_direction
	print_debug("Turning from Direction %s to Direction %s" % [Direction.keys()[old_direction], Direction.keys()[current_direction]])

func set_state(new_state: State) -> void:
	var old_state := current_state
	current_state = new_state
	print_debug("Moving from State %s to State %s" % [State.keys()[old_state], State.keys()[current_state]])
	if current_state == State.IDLE:
		match current_direction:
			Direction.N:
				play("idle_N")
			Direction.NE:
				play("idle_NE")
			Direction.E:
				play("idle_E")
			Direction.SE:
				play("idle_SE")
			Direction.S:
				play("idle_S")
			Direction.SW:
				play("idle_SW")
			Direction.W:
				play("idle_W")
			Direction.NW:
				play("idle_NW")
			_:
				play("idle_SE")
	elif current_state == State.RUN:
		match current_direction:
			Direction.N:
				play("run_N")
			Direction.NE:
				play("run_NE")
			Direction.E:
				play("run_E")
			Direction.SE:
				play("run_SE")
			Direction.S:
				play("run_S")
			Direction.SW:
				play("run_SW")
			Direction.W:
				play("run_W")
			Direction.NW:
				play("run_NW")
			_:
				play("run_SE")
