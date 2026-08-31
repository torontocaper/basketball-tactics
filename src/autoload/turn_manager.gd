@icon("uid://hb3h3lrd8n4x")
extends Node
## Turn controller.

#region Signals
## Emitted when a new player is selected. Sends their location to [CourtLayerData]
signal active_player_set(player_made_active : Player)
## Emitted when a new active team is set
signal active_team_set(team_made_active : Team)
#endregion

#region Properties
## The currently active [Team]
var active_team : Team: 
	set(value):
		active_team = value
		active_team_set.emit(active_team)
## The currently active [Player]
var active_player : Player:
	set(value):
		active_player = value
		if active_player:
			print_debug("%s active" % active_player.name)
			active_player_set.emit(active_player)
		else:
			print_debug("No active player")
			active_player_set.emit(null)
#endregion

#region Methods
## Determine which team gets first ball
func flip_coin(team_1 : Team, team_2 : Team) -> Array[Team] :
	var team_array: Array[Team] = [team_1, team_2]
	var winning_team: Team = team_array.pick_random()
	var losing_team: Team
	active_team = winning_team
	match winning_team:
		team_1:
			losing_team = team_2
		team_2:
			losing_team = team_1
	return [winning_team, losing_team]

## What to do when a [Player] is clicked. Each [Player] connects their "player_clicked" signal to this method
func on_player_clicked(clicked_player : Player) -> void:
	match clicked_player.player_state:
		Player.PlayerState.SELECTED: # If the player is already selected, unselect them
			clicked_player.player_state = Player.PlayerState.SELECTABLE
			active_player = null
		Player.PlayerState.SELECTABLE: # If the player is selectable, select them
			if active_player:
				active_player.player_state = Player.PlayerState.SELECTABLE
			clicked_player.player_state = Player.PlayerState.SELECTED
			active_player = clicked_player
		Player.PlayerState.UNSELECTABLE: # If the player is unselectable, do nothing
			return
		Player.PlayerState.MOVING:
			return
		_:
			return
#endregion
