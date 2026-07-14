#@tool
#@icon(icon_path)
class_name UIOpen
extends Control
## Documentation comments

var ui_parent: UI

@onready var start_button = %StartButton

# OVERRIDES

func _ready():
	print_debug("UIOpen ready at %s ms" % Time.get_ticks_msec())
	ui_parent = get_parent() as UI
	_connect_signals()

# CORE

# PRIVATE/HELPER
func _connect_signals():
	start_button.connect("pressed", _on_start_button_pressed)

# RECEIVERS
func _on_start_button_pressed() -> void:
	ui_parent.current_ui_state = ui_parent.UIState.MAIN
