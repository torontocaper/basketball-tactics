@icon("uid://lh2py1qa2s3n")
extends Node
## Autoload responsible for creating and maintaining [Game]s

## The [Game] that is currently underway
var current_game : Game:
	set(value):
		if current_game:
			end_game(current_game)
		current_game = value

## End the [member current_game]
func end_game(game_to_end : Game) -> void:
	print_debug("Ending game %s" % game_to_end.name)

## Start a new [Game]
func start_game(home_team : Team, away_team : Team) -> Game:
	print_debug("GM attempting to start a new game with home team %s and away team %s" % [home_team.name, away_team.name])
	var new_game = Game.new(home_team, away_team)
	return new_game
