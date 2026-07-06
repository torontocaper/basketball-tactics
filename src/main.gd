#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. Cooredinates between, e.g., MatchManager and UI.

#enum GameState {ACTIVE, INACTIVE}

const UI_PACKED = preload("uid://dw068pdf571h8")

@onready var game_layer = $GameLayer
@onready var ui_layer = $UILayer

# OVERRIDES
func _ready() -> void:
	print_debug("Main ready at %s ms" % Time.get_ticks_msec())
	add_ui()

# CORE
func add_ui() -> void:
	var ui_scene: UI = UI_PACKED.instantiate()
	ui_scene.current_ui_state = ui_scene.UIState.OPEN
	ui_layer.add_child(ui_scene)

# PRIVATE/HELPER

# RECEIVERS
