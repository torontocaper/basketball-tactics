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
	#region Regular variables
## The score for the green team
var green_score: int = 0:
	set(value):
		green_score = value
		score_updated.emit(green_score, blue_score)

## The score for the blue team
var blue_score: int = 0:
	set(value):
		blue_score = value
		score_updated.emit(green_score, blue_score)

## The [Player]s in the game
var players_in_game: Array[Player]:
	set(value):
		players_in_game = value
		court.players_on_court = players_in_game
	#endregion

	#region Onready/child nodes
@onready var court: Court = $Court ## The Court scene
@onready var blue_team: Team = $BlueTeam ## The blue [Team]
@onready var green_team: Team = $GreenTeam ## The green [Team]
	#endregion
#endregion

#region Methods
	#region Overrides
func _ready() -> void:
	players_in_game = blue_team.players + green_team.players
	#endregion

	#region Core
## Start the game!
func start_game() -> void:
	var coin_toss_winner = TurnManager.flip_coin(green_team, blue_team)
	print_debug("%s gets first ball" % coin_toss_winner.name)
	#endregion
#endregion
