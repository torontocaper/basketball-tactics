#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. 
## 
## Coordinates between Game and UI layers.

const GAME_PACKED = preload("uid://c8ityv0juv884")
const UI_PACKED = preload("uid://dw068pdf571h8")

var game: Game
var ui: UI

@onready var game_layer = $GameLayer
@onready var ui_layer = $UILayer

# OVERRIDES
func _ready() -> void:
	print_debug("Main ready at %s ms" % Time.get_ticks_msec())
	ui = UI_PACKED.instantiate()
	ui_layer.add_child(ui)
	game = GAME_PACKED.instantiate()
	game_layer.add_child(game)
	ui.game = game
	game.ui = ui
