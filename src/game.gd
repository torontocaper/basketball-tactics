#@tool
#@icon(icon_path)
class_name Game
extends Node2D
## Documentation comments

signal game_state_changed

enum GameState {ACTIVE}

const MATCH_MANAGER = preload("uid://c8ityv0juv884")

@export var current_game_state: GameState:
	set(value):
		current_game_state = value
		match current_game_state:
			GameState.ACTIVE:
				start_match()
			_:
				close_game()
		game_state_changed.emit(current_game_state)

# OVERRIDES

func _ready():
	print_debug("Game ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

# CORE
func start_match() -> void:
	var new_match_manager: MatchManager = MATCH_MANAGER.instantiate()
	add_child(new_match_manager)

func close_game() -> void:
	var children = get_children()
	for child in children:
		child.queue_free()

# PRIVATE/HELPER
func _connect_signals():
	pass

# RECEIVERS
