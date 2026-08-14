@icon("uid://hb3h3lrd8n4x")
extends Node
## Turn controller.

## Emitted when a new player is selected. Sends their location to [CourtLayerData]
signal player_selected(selected_player : Player)

var green_team : Team 
var blue_team : Team 
var selected_player : Player :
	set(value):
		selected_player = value
		if selected_player:
			print_debug("%s selected" % selected_player.name)
			player_selected.emit(selected_player)
		else:
			print_debug("No player selected")
			player_selected.emit(null)

#func _ready() -> void:
	#connect("player_selected", MoveManager.update_map)

## Flip coin to determine which team gets first ball
func flip_coin(team_1 : Team, team_2 : Team) -> Array[Team] :
	var team_array: Array[Team] = [team_1, team_2]
	var winning_team: Team = team_array.pick_random()
	var losing_team: Team
	match winning_team:
		team_1:
			losing_team = team_2
		team_2:
			losing_team = team_1
	return [winning_team, losing_team]

## Each [Player] connects their "player_clicked" signal to this method
func on_player_clicked(clicked_player : Player) -> void :
	if clicked_player.is_selectable:
		clicked_player.is_selected = true
		selected_player = clicked_player
		for player in selected_player.team.players:
			if player != selected_player:
				player.is_selected = false
	elif clicked_player.is_selected:
		clicked_player.is_selected = false
		clicked_player.is_selectable = true
		selected_player = null

func end_turn(team : Team) -> void :
	team.is_active = false

func start_turn(team : Team) -> void :
	team.is_active = true
