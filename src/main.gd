#@tool
#@icon(icon_path: String)
class_name Main
extends Node2D
## Parent object for the (video) game. 
## 
## Coordinates between Game and UI layers.

#region Constants
const GAME_PACKED : PackedScene = preload("uid://c8ityv0juv884") ## The packed version of the [Game] scene
const UI_PACKED : PackedScene = preload("uid://dw068pdf571h8") ## Packed version of the [UI] scene
#endregion

#region Properties
	#region Regular variables
var game : Game ## The (basketball) game scene, where the score is updated etc.
var ui : UI ## The base/root UI scene, which handles moving between UI states
	#endregion

	#region Onready/child nodes
@onready var game_layer : CanvasLayer = $GameLayer ## The layer on which the [Game] is displayed
@onready var ui_layer : CanvasLayer = $UILayer ## The layer on which the [UI] is displayed
	#region
#endregion

#region Methods
func _ready() -> void:
	ui = UI_PACKED.instantiate()
	ui_layer.add_child(ui)
	game = GAME_PACKED.instantiate()
	game_layer.add_child(game)
#endregion
