@icon("uid://dg3f18xvus5g0")
class_name Court
extends Node2D
## The surface a [Game] is played on.

#region Properties
## The [Player]s on this court. Set from [Game]. References sent to both the [member data_layer] and [member visual_layer]
var players_on_court : Array[Player]:
	set(value):
		players_on_court = value
		for player in players_on_court:
			visual_layer.snap_player_to_grid(player)
			data_layer.occupied_cells[player] = player.coords

@onready var data_layer: CourtLayerData = $DataLayer ## The [CourtLayer] that handles data processing, including navigation information and occupied cells
@onready var visual_layer: CourtLayerVisual = $VisualLayer ## The [CourtLayer] that handles visual presentation, including displaying move distances and animations
#endregion
