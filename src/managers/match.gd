#@tool
@icon("uid://3qwgg5y3fkjd")
class_name Match
extends Node2D
## Manager class for a particular match/game. Delegates as necessary.

@export var away_team: Team:
	set(value):
		away_team = value
		print_debug("MM has an away team")
		#if not is_node_ready():
			#await ready
		scoreboard.away_team = away_team
		#await turn_manager.ready
		turn_manager.away_team = away_team
		away_team_players = _add_players_to_team(away_team)
		players_in_game.append(away_team_players)


@export var home_team: Team:
	set(value):
		home_team = value
		print_debug("MM has a home team")
		#if not is_node_ready():
			#await ready
		#await scoreboard.ready
		scoreboard.home_team = home_team
		#await turn_manager.ready
		turn_manager.home_team = home_team
		home_team_players = _add_players_to_team(home_team)
		players_in_game.append(away_team_players)

@export var scoreboard: Scoreboard:
	set(value):
		scoreboard = value

@onready var court = $Court

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		scoreboard.away_team_score.text = "%02d" % away_team_score

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		scoreboard.home_team_score.text = "%02d" % home_team_score

var away_team_players: Array[Player]:
	set(value):
		away_team_players = value
		turn_manager.away_team_players = away_team_players

var home_team_players: Array[Player]:
	set(value):
		home_team_players = value
		turn_manager.home_team_players = home_team_players

var players_in_game: Array[Player]:
	set(value):
		players_in_game = value
		court.players_on_court = players_in_game

var possessing_team: Team:
	set(value):
		possessing_team = value
		if not is_node_ready():
			await ready
		scoreboard.possessing_team = possessing_team
		turn_manager.possessing_team = possessing_team

@onready var turn_manager: TurnManager = %TurnManager

func _ready() -> void:
	print_debug("MatchManager ready")
	_connect_signals()
	#_fill_in_scoreboard()

func start_match() -> void:
	print_debug("Starting match")
	possessing_team = _flip_coin(away_team, home_team)
	print_debug("%s gets first ball" % possessing_team.name)
	_set_player_starting_positions()

# PRIVATE/HELPER
func _add_players_to_team(team: Team) -> Array[Player]:
	print_debug("Adding players to %s" % team.name)
	var player_nodes = team.get_children()
	var players: Array[Player]
	for node in player_nodes:
		var player = node as Player
		players.append(player)
	return players

func _connect_signals() -> void:
	for player in players_in_game:
		player.connect("player_clicked", turn_manager.on_player_clicked)

func _flip_coin(team_1: Team, team_2: Team) -> Team:
	var teams = [team_1, team_2]
	var coin_toss_winner: Team = teams.pick_random()
	print_debug("%s won the coin toss" % coin_toss_winner.team_name)
	return coin_toss_winner

func _set_player_starting_positions() -> void:
	match possessing_team:
		away_team:
			for player in away_team_players:
				var starting_point = court.starting_points_offense.pop_at(randi_range(0, court.starting_points_offense.size() - 1))
				player.position = starting_point.position
				print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
			for player in home_team_players:
				var starting_point = court.starting_points_defense.pop_at(randi_range(0, court.starting_points_defense.size() - 1))
				player.position = starting_point.position
				print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
		home_team:
			for player in home_team_players:
				var starting_point = court.starting_points_offense.pop_at(randi_range(0, court.starting_points_offense.size() - 1))
				player.position = starting_point.position
				print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])
			for player in away_team_players:
				var starting_point = court.starting_points_defense.pop_at(randi_range(0, court.starting_points_defense.size() - 1))
				player.position = starting_point.position
				print_debug("Assigning %s to %s, position %s" % [player.name, starting_point.name, starting_point.position])

## RECEIVERS
