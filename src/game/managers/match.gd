#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Match
extends Node2D
## Manager class for a particular match/game.

signal score_updated

const COURT = preload("uid://qscdb7q3way3")
const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")

var court: Court:
	set(value):
		court = value

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

var away_team_players: Array[Player]:
	set(value):
		away_team_players = value

var home_team_players: Array[Player]:
	set(value):
		home_team_players = value

var possessing_team: Team:
	set(value):
		possessing_team = value

func _ready() -> void:
	print_debug("Match ready at %s ms" % Time.get_ticks_msec())
	#_connect_signals()
	start_match()

func start_match() -> void:
	print_debug("Starting match")
	court = COURT.instantiate()
	add_child(court)
	away_team = GREEN_TEAM.instantiate()
	add_child(away_team)
	home_team = BLUE_TEAM.instantiate()
	add_child(home_team)
	possessing_team = _flip_coin(away_team, home_team)
	print_debug("%s gets first ball" % possessing_team.team_name)
	#_set_player_starting_positions()

# PRIVATE/HELPER
func _add_players_to_team(team: Team) -> Array[Player]:
	print_debug("Adding players to %s" % team.name)
	var player_nodes = team.get_children()
	var players: Array[Player]
	for node in player_nodes:
		var player = node as Player
		players.append(player)
	return players

#func _connect_signals() -> void:
	#for player in players_in_game:
		#player.connect("player_clicked", turn_manager.on_player_clicked)

func _flip_coin(team_1: Team, team_2: Team) -> Team:
	var teams = [team_1, team_2]
	var coin_toss_winner: Team = teams.pick_random()
	print_debug("%s won the coin toss" % coin_toss_winner.team_name)
	return coin_toss_winner

#func _set_player_starting_positions() -> void:
	#match possessing_team:
		#away_team:
			#for player in away_team_players:
				#var starting_point = court.starting_points_offense.pop_at(randi_range(0, court.starting_points_offense.size() - 1))
				#player.position = starting_point.position
				#print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
			#for player in home_team_players:
				#var starting_point = court.starting_points_defense.pop_at(randi_range(0, court.starting_points_defense.size() - 1))
				#player.position = starting_point.position
				#print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
		#home_team:
			#for player in home_team_players:
				#var starting_point = court.starting_points_offense.pop_at(randi_range(0, court.starting_points_offense.size() - 1))
				#player.position = starting_point.position
				#print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
			#for player in away_team_players:
				#var starting_point = court.starting_points_defense.pop_at(randi_range(0, court.starting_points_defense.size() - 1))
				#player.position = starting_point.position
				#print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])

## RECEIVERS
