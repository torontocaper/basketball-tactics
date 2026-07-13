#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node2D
## The Game layer. Also a basketball game.

signal possession_changed(value: Team)
signal score_updated(away_score: int, home_score: int)

const COURT = preload("uid://qscdb7q3way3")
const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")

@export var ui: UI:
	set(value):
		ui = value

var away_team: Team:
	set(value):
		away_team = value
		turn_manager.away_team = away_team

var home_team: Team:
	set(value):
		home_team = value
		turn_manager.home_team = home_team

var possessing_team: Team:
	set(value):
		possessing_team = value
		turn_manager.possessing_team = possessing_team
		possession_changed.emit(possessing_team)

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		score_updated.emit(away_team_score, home_team_score)

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		score_updated.emit(away_team_score, home_team_score)

@onready var court: Court = $Court
@onready var turn_manager: TurnManager = $TurnManager
@onready var blue_team: Team = $BlueTeam
@onready var green_team: Team = $GreenTeam

func _ready() -> void:
	print_debug("Game ready at %s ms" % Time.get_ticks_msec())

func start_game() -> void:
	home_team = blue_team
	away_team = green_team
	possessing_team = turn_manager.flip_coin(home_team, away_team)
	print_debug("%s gets first ball" % possessing_team.team_name)
