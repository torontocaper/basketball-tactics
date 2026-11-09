@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node
## The (basketball) game.

#region SIGNALS
## Emitted when the score changes
signal score_updated(team : Team, new_score : int)
#endregion

#region PROPERTIES
#region Exports
@export var home_team : Team
@export var away_team : Team

#region Regular variables
## The score for the green team
var home_score: int = 0:
	set(value):
		home_score = value
		score_updated.emit(home_team, home_score)

## The score for the blue team
var away_score: int = 0:
	set(value):
		away_score = value
		score_updated.emit(away_team, away_score)

## The [Player]s in the game; sent to the [member court] when set
var players_in_game: Array[Player]:
	set(value):
		players_in_game = value
		court.players_on_court = players_in_game
#endregion

#region Onready/child nodes
## The [Court] scene, which contains both a 'data' layer and a 'visual' layer. Both receive references to [member players_in_game]
@onready var court: Court = $Court
## The blue [Team]
@onready var blue_team: Team = $BlueTeam 
## The green [Team]
@onready var green_team: Team = $GreenTeam
#endregion
#endregion

#region METHODS
#region Overrides
func _init(home : Team, away : Team) -> void:
	print_debug("Initializing a game with home team %s and away team %s" % [home.name, away.name])
	home_team = home
	away_team = away
	players_in_game = home_team.players + away_team.players
#endregion

#region Core
## Start (or restart) the game!
func start_game() -> void:
	var coin_toss_winner = TurnManager.flip_coin(green_team, blue_team)
	print_debug("%s gets first ball" % coin_toss_winner.name)
#endregion
#endregion
