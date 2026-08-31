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
	#region Overrides
func _ready() -> void:
	players_in_game = blue_team.players + green_team.players
	#endregion

	#region Core
## Start the game!
func start_game() -> void:
	var coin_toss_results = TurnManager.flip_coin(green_team, blue_team)
	var coin_toss_winner = coin_toss_results[0]
	var coin_toss_loser = coin_toss_results[1]
	print_debug("%s gets first ball" % coin_toss_winner.name)
	coin_toss_winner.team_state = Team.TeamState.ACTIVE
	coin_toss_loser.team_state = Team.TeamState.INACTIVE
	#endregion
#endregion
