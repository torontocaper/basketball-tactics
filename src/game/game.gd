@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node2D
## The (basketball) game.

#region Signals
## Emitted when the score changes
signal score_updated(new_green_score: int, new_blue_score: int)
#endregion

#region Enums
enum GameState {
	PAUSED,
	ACTIVE
}
#endregion

#region Properties
	#region Regular variables
## The current state of the game
var game_state : GameState = GameState.PAUSED:
	set(value):
		game_state = value

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
## The [Court] scene, which contains both a 'data' layer and a 'visual' layer. Both receive references to [member players_in_game]
@onready var court: Court = $Court
## The blue [Team]
@onready var blue_team: Team = $BlueTeam 
## The green [Team]
@onready var green_team: Team = $GreenTeam
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
