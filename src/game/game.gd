@icon("uid://b03b5v1eswnsf")
class_name Game
extends Node
## The (basketball) game. Created by [GameManager] after users select their teams

#region SIGNALS
## Emitted when the score changes
signal score_updated(team : Team, new_score : int)
#endregion

#region PROPERTIES

#region Regular variables
## The home team
var home_team : Team

## The away team
var away_team : Team

## The score for the home team
var home_score: int = 0:
	set(value):
		home_score = value
		score_updated.emit(home_team, home_score)

## The score for the away team
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
#endregion
#endregion

#region METHODS
#region Overrides
func _ready() -> void:
	if home_team and away_team:
		print_debug("Starting a new game")
		var children := get_children()
		for child in children:
			if child is Team:
				child.queue_free()
		add_child(home_team)
		add_child(away_team)
		start_game()
#endregion

#region Core
## Start (or restart) the game!
func start_game() -> void:
	var coin_toss_winner = TurnManager.flip_coin(home_team, away_team)
	print_debug("%s gets first ball" % coin_toss_winner.name)
#endregion
#endregion
