#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. 
## 
## Coordinates between Game and UI layers.

#region PROPERTIES
#region Onready/child nodes
@onready var game_layer : CanvasLayer = $GameLayer ## The layer on which gameplay elements are displayed
@onready var ui_layer : CanvasLayer = $UILayer ## The layer on which user interface elements are displayed
#region
#endregion

#region METHODS
func _ready() -> void:
	UiManager.ui_updated.connect(_update_ui)
	GameManager.game_updated.connect(_update_game)
	UiManager.current_ui_state = UiManager.UIState.OPEN
	#GameManager.current_game_state = GameManager.GameState.HIDDEN

func _update_game(game : Game, game_state : GameManager.GameState) -> void:
	if game_state == GameManager.GameState.ACTIVE:
		game_layer.add_child(game)

func _update_ui(new_ui_scene : Control) -> void:
	# Clear existing UI nodes, if necessary
	var scenes_to_close : Array[Node] = ui_layer.get_children()
	for scene in scenes_to_close:
		scene.queue_free()
	ui_layer.add_child(new_ui_scene)
#endregion
