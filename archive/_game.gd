#@tool
#@icon(icon_path)
#class_name Game
extends Node2D
## Documentation comments

signal game_state_changed(state: GameState)

enum GameState {MATCH}

const MATCH = preload("uid://c8ityv0juv884")

@export var current_game_state: GameState:
	set(value):
		current_game_state = value
		match current_game_state:
			GameState.MATCH:
				#start_match()
			_:
				close_game()
		game_state_changed.emit(current_game_state)

@export var ui: UI:
	set(value):
		ui = value
		print_debug("Game has a UI")

# OVERRIDES

func _ready():
	print_debug("Game ready at %s ms" % Time.get_ticks_msec())

## CORE
#func start_match() -> void:
	##var new_match: Match = MATCH.instantiate()
	##add_child(new_match)

func close_game() -> void:
	var children = get_children()
	for child in children:
		child.queue_free()

# PRIVATE/HELPER


# RECEIVERS
