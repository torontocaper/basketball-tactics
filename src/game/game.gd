#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node2D
## The game layer. Also a basketball game.

signal score_updated(new_green_score: int, new_blue_score: int)

@export var ui: UI:
	set(value):
		ui = value

var green_score: int = 0:
	set(value):
		green_score = value
		score_updated.emit(green_score, blue_score)

var blue_score: int = 0:
	set(value):
		blue_score = value
		score_updated.emit(green_score, blue_score)

@onready var court: Court = $Court
@onready var turn_manager: TurnManager = $TurnManager
@onready var blue_team: Team = $BlueTeam
@onready var green_team: Team = $GreenTeam

func _ready() -> void:
	print_debug("Game ready at %s ms" % Time.get_ticks_msec())
	turn_manager.green_team = green_team
	turn_manager.blue_team = blue_team
	court.players_on_court = blue_team.players + green_team.players

func start_game() -> void:
	green_team.is_active = false
	blue_team.is_active = false
	var coin_toss_results = turn_manager.flip_coin(green_team, blue_team)
	var coin_toss_winner = coin_toss_results[0]
	var coin_toss_loser = coin_toss_results[1]
	print_debug("%s gets first ball" % coin_toss_winner.team_name)
	coin_toss_winner.has_ball = true
	coin_toss_loser.has_ball = false
	turn_manager.start_turn(coin_toss_winner)
