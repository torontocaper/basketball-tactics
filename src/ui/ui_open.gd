#@tool
#@icon(icon_path)
class_name UIOpen
extends Control
## The opening/title screen

#region PROPERTIES
@onready var start_button = %StartButton
#endregion

#region METHODS
func _ready():
	start_button.connect("pressed", _on_start_button_pressed)

func _on_start_button_pressed() -> void:
	UiManager.current_ui_state = UiManager.UIState.MAIN
#endregion
