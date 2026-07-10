#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. 
## 
## Coordinates between Game and UI layers. Manages high-level scene instantiation.

const GAME_PACKED = preload("uid://cl8r0gwg28e12")
const UI_PACKED = preload("uid://dw068pdf571h8")

var game: Game
var ui: UI

@onready var game_layer = $GameLayer
@onready var ui_layer = $UILayer

# OVERRIDES
func _ready() -> void:
	print_debug("Main ready at %s ms" % Time.get_ticks_msec())
	game = GAME_PACKED.instantiate()
	ui = UI_PACKED.instantiate()
	_connect_signals()
	game_layer.add_child(game)
	ui_layer.add_child(ui)

# PRIVATE/HELPER
func _connect_signals() -> void:
	game.connect("game_state_changed", _on_game_state_changed)
	ui.connect("ui_state_changed", _on_ui_state_changed)

# RECEIVERS
func _on_game_state_changed(new_state: Game.GameState) -> void:
	print_debug("Game has entered new state: %s" % Game.GameState.keys()[new_state])

func _on_ui_state_changed(new_state: UI.UIState) -> void:
	print_debug("UI has entered new state: %s" % UI.UIState.keys()[new_state])
	match new_state:
		UI.UIState.OPEN:
			pass
		UI.UIState.MAIN:
			game.current_game_state = Game.GameState.MATCH
		_:
			print_debug("Invalid UI state")
