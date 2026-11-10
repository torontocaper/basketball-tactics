@icon("uid://lh2py1qa2s3n")
extends Node
## Autoload responsible for creating and maintaining [Game]s

#region SIGNALS
signal game_started(game : Game)
#endregion

#region CONSTANTS
const GAME = preload("uid://c8ityv0juv884")
#endregion

#region PROPERTIES
## The [Game] that is currently underway
var current_game : Game:
	set(value):
		current_game = value
		game_started.emit(current_game)
#endregion

#region METHODS
## Start a new [Game]
func start_game(home : Team, away : Team) -> void:
	print_debug("GM attempting to start a new game with home team %s and away team %s" % [home.name, away.name])
	var new_game = GAME.instantiate() as Game
	new_game.home_team = home
	new_game.away_team = away
	current_game = new_game
#endregion
