@icon("uid://cmppnat65qm1e")
class_name Court
extends Node2D
## The surface a [Game] is played on.

#region PROPERTIES
## The cells in home territory
var home_cells : Array[Vector2i]

## The potential starting cells for [member home_players]
var home_starting_cells : Array[Vector2i]

## The potential starting cells for [member away_players]
var away_starting_cells : Array[Vector2i]

## The cells in away territory
var away_cells : Array[Vector2i]

## The [Player]s on the home team
var home_players : Array[Player]:
	set(value):
		home_players = value
		for player in home_players:
			player.court = self
			var player_starting_cell : Vector2i = home_starting_cells.pick_random()
			while player_starting_cell in data_layer.occupied_cells.values():
				player_starting_cell = home_starting_cells.pick_random()
			player.coords = player_starting_cell

## The [Player]s on the away team
var away_players : Array[Player]:
	set(value):
		away_players = value
		for player in away_players:
			player.court = self
			var player_starting_cell : Vector2i = away_starting_cells.pick_random()
			while player_starting_cell in data_layer.occupied_cells.values():
				player_starting_cell = away_starting_cells.pick_random()
			player.coords = player_starting_cell

## The [Player]s on this court. Set from [Game]. 
## References sent to both [member data_layer] (for setting [member CourtLayerData.occupied_cells]) and [member visual_layer] (for grid-snapping).
var players_on_court : Array[Player]:
	set(value):
		players_on_court = value
		for player in players_on_court:
			player.court = self
			data_layer.occupied_cells[player] = player.coords #TODO: can hopefully eliminate this

## The [CourtLayer] that handles data processing, including navigation information and occupied cells
@onready var data_layer: CourtLayerData = $DataLayer 

## The [CourtLayer] that handles visual presentation, including displaying move distances and animations
@onready var visual_layer: CourtLayerVisual = $VisualLayer 
#endregion

#region METHODS
func _ready() -> void:
	var all_cells : Array[Vector2i] = data_layer.court_cells
	home_cells = all_cells.filter(func(cell): return data_layer.get_cell_tile_data(cell).get_custom_data("team_territory") == "home")
	away_cells = all_cells.filter(func(cell): return data_layer.get_cell_tile_data(cell).get_custom_data("team_territory") == "away")
	home_starting_cells = home_cells.filter(func(cell): return data_layer.get_cell_tile_data(cell).get_custom_data("points") == 2 and data_layer.get_cell_tile_data(cell).get_custom_data("is_hoop") == false)
	away_starting_cells = away_cells.filter(func(cell): return data_layer.get_cell_tile_data(cell).get_custom_data("points") == 2 and data_layer.get_cell_tile_data(cell).get_custom_data("is_hoop") == false)
#endregion
