#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Game
extends Node2D
## The Game layer. Also a basketball game.

signal score_updated(away_score: int, home_score: int)

const COURT = preload("uid://qscdb7q3way3")
const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")

@export var ui: UI:
	set(value):
		ui = value
		print_debug("Game has a UI")

var away_team: Team
var home_team: Team

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		score_updated.emit(away_team_score, home_team_score)

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		score_updated.emit(away_team_score, home_team_score)

#var away_team_players: Array[Player]
#var home_team_players: Array[Player]

var possessing_team: Team

@onready var court: Court = $Court
@onready var blue_team: Team = $BlueTeam
@onready var green_team: Team = $GreenTeam

func _ready() -> void:
	print_debug("Game ready at %s ms" % Time.get_ticks_msec())

func start_game() -> void:
	home_team = blue_team
	away_team = green_team
	possessing_team = _flip_coin(away_team, home_team)
	print_debug("%s gets first ball" % possessing_team.team_name)
	#print_debug("Starting game at %s ms" % Time.get_ticks_msec())
	##court = COURT.instantiate()
	##add_child(court)
	##away_team = GREEN_TEAM.instantiate()
	##add_child(away_team)
	##home_team = BLUE_TEAM.instantiate()
	##add_child(home_team)
	#possessing_team = 

# PRIVATE/HELPER
#func _add_players_to_team(team: Team) -> Array[Player]:
	#print_debug("Adding players to %s" % team.name)
	#var player_nodes = team.get_children()
	#var players: Array[Player]
	#for node in player_nodes:
		#var player = node as Player
		#players.append(player)
	#print_debug("%s has %s players" % [team.team_name, str(players.size())])
	#return players

func _flip_coin(team_1: Team, team_2: Team) -> Team:
	var teams = [team_1, team_2]
	var coin_toss_winner: Team = teams.pick_random()
	print_debug("%s won the coin toss" % coin_toss_winner.team_name)
	return coin_toss_winner

## RECEIVERS
