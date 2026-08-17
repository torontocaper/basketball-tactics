@icon("uid://dg3f18xvus5g0")
class_name Court
extends Node2D
## The surface a [Game] is played on.

var players_on_court : Array[Player]:
	set(value):
		players_on_court = value
		for player in players_on_court:
			snap_player_to_grid(player)
			data_layer.occupied_cells[player] = player.coords

@onready var data_layer: CourtLayerData = $DataLayer
@onready var visual_layer: CourtLayerVisual = $VisualLayer

func _ready() -> void:
	pass

func snap_player_to_grid(player_to_snap : Player) -> void:
	player_to_snap.position = data_layer.map_to_local(player_to_snap.coords)
