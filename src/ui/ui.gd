#@tool
#@icon(icon_path)
class_name UI
extends Control
## Documentation comments

#signal
enum UIState {OPEN, MAIN}

const UI_OPEN = preload("uid://coo2i8qmmqdt3")
const UI_MAIN = preload("uid://bfe1neokvy2mo")
const UI_ERROR = preload("uid://dnsdv2iate647")

@export var current_ui_state: UIState:
	set(value):
		current_ui_state = value
		open_new_ui_scene(current_ui_state)

# OVERRIDES
func _ready():
	print_debug("UI ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

# CORE
func open_new_ui_scene(ui_state: UIState) -> void:
	var scenes_to_close: Array[Node] = get_children()
	for scene in scenes_to_close:
		scene.queue_free()
	var scene_to_open: PackedScene
	match ui_state:
		UIState.OPEN:
			scene_to_open = UI_OPEN
		UIState.MAIN:
			scene_to_open = UI_MAIN
		_:
			scene_to_open = UI_ERROR
	var instantiated_scene:= scene_to_open.instantiate()
	add_child(instantiated_scene)


# PRIVATE/HELPER
func _connect_signals():
	pass

# RECEIVERS
