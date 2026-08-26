#@tool
#@icon(icon_path)
class_name UIOpen
extends Control
## The opening/title screen

#region Properties
@onready var start_button = %StartButton
#endregion

#region Methods
func _ready():
	print_debug("UIOpen ready at %s ms" % Time.get_ticks_msec())
	#ui_parent = get_parent() as UI
	start_button.connect("pressed", _on_start_button_pressed)

func _on_start_button_pressed() -> void:
	var main : Main = get_tree().current_scene
	var ui : UI = main.ui
	ui.current_ui_state = ui.UIState.MAIN
#endregion
