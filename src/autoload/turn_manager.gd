@icon("uid://hb3h3lrd8n4x")
extends Node
## Turn controller. Responsible for changing Player and Team states.

#region Signals
## Emitted when a new player is selected. Sends their location to [CourtLayerData]
signal active_player_set(player_made_active : Player)
## Emitted when a new active team is set
signal active_team_set(team_made_active : Team)
## Emitted when a turn is over
signal turn_ended
#endregion

#region Properties
## The currently active [Team]
var active_team : Team: 
	set(value):
		# If there's already an active_team, make that team inactive
		if active_team:
			inactive_team = active_team
		# Assign the new team to the active_team variable
		active_team = value
		# Change that team's state to ACTIVE
		active_team.team_state = Team.TeamState.ACTIVE
		# Emit the active_team_set signal
		active_team_set.emit(active_team)
		# Start the turn for the new active_team
		start_turn(active_team)

## The currently inactive [Team]
var inactive_team : Team:
	set(value):
		inactive_team = value
		# Change the team's state to INACTIVE
		inactive_team.team_state = Team.TeamState.INACTIVE

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
## Determine which team gets first ball. Called from [Game] in [method Game.start_game]
func flip_coin(team_1 : Team, team_2 : Team) -> Team:
	if randi() % 2:
		active_team = team_1
		inactive_team = team_2
	else:
		active_team = team_2
		inactive_team = team_1
	return active_team

## What to do when a [Player] is clicked. Each [Player] connects their "player_clicked" signal to this method
func on_player_clicked(clicked_player : Player) -> void:
	match clicked_player.player_state:
		# If the player is already selected, unselect them
		Player.PlayerState.SELECTED: 
			clicked_player.player_state = Player.PlayerState.SELECTABLE
			active_player = null
		# If the player is selectable, select them
		Player.PlayerState.SELECTABLE: 
			if active_player:
				active_player.player_state = Player.PlayerState.SELECTABLE
			clicked_player.player_state = Player.PlayerState.SELECTED
			active_player = clicked_player
		# If the player is unselectable, do nothing
		Player.PlayerState.UNSELECTABLE: 
			return
		Player.PlayerState.MOVING:
			return
		_:
			return

## End the [member active_team]'s turn
func end_turn() -> void:
	print_debug("Ending turn for %s" % active_team.name)
	# Make the inactive_team the new active_team
	active_team = inactive_team
	# Clear the active_player variable
	active_player = null
	turn_ended.emit()

## Start the turn for [param turn_team]
func start_turn(turn_team : Team) -> void:
	print_debug("Starting turn for %s" % turn_team.name)
#endregion
