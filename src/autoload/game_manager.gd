@icon("uid://b03b5v1eswnsf")
extends Node
## Autoload responsible for creating and maintaining [Game]s

#region SIGNALS
signal game_updated(game : Game, game_state : GameState)
#endregion

#region ENUMS
## Possible states the [Game] can exist in
enum GameState {
	HIDDEN,
	ACTIVE,
	PAUSED
}
#region

#region CONSTANTS
const GAME_PACKED = preload("uid://c8ityv0juv884")
#endregion

#region PROPERTIES
## The [Game] that is currently underway
var current_game : Game:
	set(value):
		current_game = value

## The state of the current [Game]. Update signal is sent to [Main]
var current_game_state : GameState = GameState.HIDDEN:
	set(value):
		current_game_state = value
		game_updated.emit(current_game, current_game_state)
#endregion

#region METHODS
## Set up a new [Game]. Called from [UIMain] when both users have selected a team and clicked 'ready'
func set_up_game(home : Team, away : Team) -> void:
	print_debug("GM attempting to set up a new game with home team %s and away team %s" % [home.name, away.name])
	var new_game = GAME_PACKED.instantiate() as Game
	new_game.home_team = home
	new_game.away_team = away
	current_game = new_game
	current_game_state = GameState.ACTIVE
#endregion
