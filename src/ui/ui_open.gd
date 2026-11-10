#@tool
#@icon(icon_path)
class_name UIOpen
extends Control
## The opening/title screen

#region CONSTANTS
const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")
#endregion

#region PROPERTIES
@onready var start_button = %StartButton
#endregion

#region METHODS
func _ready():
	start_button.connect("pressed", _on_start_button_pressed)

func _on_start_button_pressed() -> void:
	var blue : Team = BLUE_TEAM.instantiate()
	var green : Team = GREEN_TEAM.instantiate()
	GameManager.start_game(blue, green)
	UiManager.current_ui_state = UiManager.UIState.MAIN
#endregion
