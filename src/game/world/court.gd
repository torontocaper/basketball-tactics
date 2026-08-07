@icon("uid://dg3f18xvus5g0")
class_name Court
extends Node2D
## The surface a [Game] is played on.

#@onready var court_layer_data: CourtLayerData = $CourtLayerData
#@onready var court_layer_visual: CourtLayerVisual = $CourtLayerVisual
#
#var court_layers: Array[CourtLayer]

#region OVERRIDES
#func _ready() -> void:
	#court_layers = [court_layer_data, court_layer_visual]

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_pressed() and event is InputEventMouseButton:
		#var click_position : Vector2 = event.position
		#for layer in court_layers:
			#layer.handle_click_at_position(click_position)
#endregion
