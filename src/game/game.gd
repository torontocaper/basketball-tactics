#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node2D
## The (basketball) game.

#region Signals
## Emitted when the score changes
signal score_updated(new_green_score: int, new_blue_score: int)
#endregion

#region Properties
var green_score: int = 0:
	set(value):
		green_score = value
		score_updated.emit(green_score, blue_score)

var blue_score: int = 0:
	set(value):
		blue_score = value
		score_updated.emit(green_score, blue_score)

var players_in_game: Array[Player]:
	set(value):
		players_in_game = value
		court.players_on_court = players_in_game

@onready var court: Court = $Court
@onready var blue_team: Team = $BlueTeam
@onready var green_team: Team = $GreenTeam
#endregion

#region Methods
func _ready() -> void:
	players_in_game = blue_team.players + green_team.players
	TurnManager.blue_team = blue_team
	TurnManager.green_team = green_team

## Start the game!
func start_game() -> void:
	green_team.is_active = false
	blue_team.is_active = false
	var coin_toss_results = TurnManager.flip_coin(green_team, blue_team)
	var coin_toss_winner = coin_toss_results[0]
	var coin_toss_loser = coin_toss_results[1]
	print_debug("%s gets first ball" % coin_toss_winner.name)
	coin_toss_winner.has_ball = true
	coin_toss_loser.has_ball = false
	TurnManager.start_turn(coin_toss_winner)
