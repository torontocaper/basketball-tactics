extends Node
## Autoload for managing UI state

#region SIGNALS
signal ui_updated(new_ui_scene : Control)

#region ENUMS
enum UIState {OPEN, MAIN}
#endregion

#region CONSTANTS
const UI_OPEN = preload("uid://coo2i8qmmqdt3")
const UI_MAIN = preload("uid://bfe1neokvy2mo")
const UI_ERROR = preload("uid://dnsdv2iate647")
#endregion

#region PROPERTIES
@export var current_ui_state: UIState:
	set(value):
		current_ui_state = value
		print_debug("UI has new state: %s" % UIState.keys()[current_ui_state])
		current_ui_scene = open_new_ui_scene(current_ui_state)
		ui_updated.emit(current_ui_scene)

var current_ui_scene : Control
#endregion

#region METHODS
func _ready():
	current_ui_state = UIState.OPEN

func open_new_ui_scene(ui_state: UIState) -> Control:
	var scene_to_open : PackedScene
	match ui_state:
		UIState.OPEN:
			scene_to_open = UI_OPEN
		UIState.MAIN:
			scene_to_open = UI_MAIN
		_:
			scene_to_open = UI_ERROR
	var instantiated_scene : Control = scene_to_open.instantiate()
	return instantiated_scene
#endregion
