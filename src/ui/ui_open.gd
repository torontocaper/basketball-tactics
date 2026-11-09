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
	start_button.connect("pressed", _on_start_button_pressed)

func _on_start_button_pressed() -> void:
	var main : Main = get_tree().current_scene
	UiManager.current_ui_state = UiManager.UIState.MAIN
#endregion
