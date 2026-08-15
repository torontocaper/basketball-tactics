@icon("uid://hb3h3lrd8n4x")
extends Node
## Turn controller.

## Emitted when a new player is selected. Sends their location to [CourtLayerData]
signal active_player_set(player_made_active : Player)

var green_team : Team 
var blue_team : Team 
var active_player : Player:
	set(value):
		active_player = value
		if active_player:
			print_debug("%s selected" % active_player.name)
			active_player_set.emit(active_player)
		else:
			print_debug("No player selected")
			active_player_set.emit(null)

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

## Each [Player] connects their "player_selected" signal to this method
func on_player_clicked(clicked_player : Player) -> void:
	match clicked_player.player_state:
		Player.PlayerState.SELECTED:
			clicked_player.player_state = Player.PlayerState.SELECTABLE
			active_player = null
		Player.PlayerState.SELECTABLE:
			if active_player:
				active_player.player_state = Player.PlayerState.SELECTABLE
			clicked_player.player_state = Player.PlayerState.SELECTED
			active_player = clicked_player
		Player.PlayerState.UNSELECTABLE:
			return
		Player.PlayerState.MOVING:
			return
		_:
			return
	
func end_turn(team : Team) -> void :
	team.is_active = false

func start_turn(team : Team) -> void :
	team.is_active = true
