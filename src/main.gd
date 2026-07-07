#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. Cooredinates between, e.g., MatchManager and UI.

const GAME_PACKED = preload("uid://cl8r0gwg28e12")
const UI_PACKED = preload("uid://dw068pdf571h8")

var game: Game
var ui: UI

@onready var game_layer = $GameLayer
@onready var ui_layer = $UILayer

# OVERRIDES
func _ready() -> void:
	print_debug("Main ready at %s ms" % Time.get_ticks_msec())
	game = create_game()
	add_game(game)
	ui = create_ui()
	add_ui(ui)

# CORE
func create_game() -> Game:
	var game_scene: Game = GAME_PACKED.instantiate()
	return game_scene

func add_game(new_game: Game) -> void:
	#new_game.current_game_state = new_game.GameState.ACTIVE
	new_game.connect("game_state_changed", _on_game_state_changed)
	game_layer.add_child(new_game)

func create_ui() -> UI:
	var ui_scene: UI = UI_PACKED.instantiate()
	return ui_scene

func add_ui(new_ui: UI) -> void:
	new_ui.current_ui_state = new_ui.UIState.OPEN
	new_ui.connect("ui_state_changed", _on_ui_state_changed)
	ui_layer.add_child(new_ui)

# PRIVATE/HELPER

# RECEIVERS
func _on_game_state_changed(_new_state: Game.GameState) -> void:
	pass

func _on_ui_state_changed(new_state: UI.UIState) -> void:
	match new_state:
		UI.UIState.MAIN:
			game.current_game_state = Game.GameState.ACTIVE
		_:
			print_debug("Invalid UI state")
