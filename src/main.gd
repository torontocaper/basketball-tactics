#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. 
## 
## Coordinates between Game and UI layers.

#region CONSTANTS
#endregion

#region PROPERTIES
#region Regular variables
#endregion

#region Onready/child nodes
@onready var game_layer : CanvasLayer = $GameLayer ## The layer on which the [Game] is displayed
@onready var ui_layer : CanvasLayer = $UILayer ## The layer on which the [UI] is displayed
#region
#endregion

#region METHODS
func _ready() -> void:
	ui_layer.add_child(UiManager.current_ui_scene)
	UiManager.ui_updated.connect(_update_ui)

func _update_ui(new_ui_scene : Control) -> void:
	# Clear existing UI nodes, if necessary
	var scenes_to_close : Array[Node] = ui_layer.get_children()
	for scene in scenes_to_close:
		scene.queue_free()
	ui_layer.add_child(new_ui_scene)
#endregion
