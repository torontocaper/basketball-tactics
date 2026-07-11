#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Match
extends Node2D
## Manager class for a particular match/game.

signal score_updated(away_score: int, home_score: int)

const COURT = preload("uid://qscdb7q3way3")
const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")

var court: Court

var away_team: Team:
	set(value):
		away_team = value
		away_team_players = _add_players_to_team(away_team)

var home_team: Team:
	set(value):
		home_team = value
		home_team_players = _add_players_to_team(home_team)

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		score_updated.emit(away_team_score, home_team_score)

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		score_updated.emit(away_team_score, home_team_score)

var away_team_players: Array[Player]
var home_team_players: Array[Player]

var possessing_team: Team

func _ready() -> void:
	print_debug("Match ready at %s ms" % Time.get_ticks_msec())
	start_match()

func start_match() -> void:
	print_debug("Starting match at %s ms" % Time.get_ticks_msec())
	court = COURT.instantiate()
	add_child(court)
	away_team = GREEN_TEAM.instantiate()
	add_child(away_team)
	home_team = BLUE_TEAM.instantiate()
	add_child(home_team)
	possessing_team = _flip_coin(away_team, home_team)
	print_debug("%s gets first ball" % possessing_team.team_name)

# PRIVATE/HELPER
func _add_players_to_team(team: Team) -> Array[Player]:
	print_debug("Adding players to %s" % team.name)
	var player_nodes = team.get_children()
	var players: Array[Player]
	for node in player_nodes:
		var player = node as Player
		players.append(player)
	return players

func _flip_coin(team_1: Team, team_2: Team) -> Team:
	var teams = [team_1, team_2]
	var coin_toss_winner: Team = teams.pick_random()
	print_debug("%s won the coin toss" % coin_toss_winner.team_name)
	return coin_toss_winner

## RECEIVERS
