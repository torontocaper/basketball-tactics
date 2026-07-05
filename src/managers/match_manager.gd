#@tool
@icon("uid://3qwgg5y3fkjd")
class_name MatchManager
extends Node
## Manager class for a particular match/game. 

@export var court: Court

@export var away_team: Team
@export var home_team: Team

@export var players_on_court: Array[Player]

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		scoreboard.away_team_score.text = "%02d" % away_team_score

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		scoreboard.home_team_score.text = "%02d" % home_team_score

var possessing_team: Team:
	set(value):
		possessing_team = value
		print_debug("%s has the ball" % possessing_team.team_name)

var selected_player: Player:
	set(value):
		if selected_player: # If there's already a selected player, make them selectable again
			selected_player.select_state = Player.Selectability.SELECTABLE
		if value:
			selected_player = value
			print_debug("%s is the currently selected player" % selected_player.name)
			court.highlight_potential_moves(selected_player)
		else:
			print_debug("No player selected")

@onready var scoreboard: Scoreboard = %Scoreboard

func _ready() -> void:
	_connect_signals()
	print_debug("%s ready" % name)
	_fill_in_scoreboard()
	possessing_team = _flip_coin(away_team, home_team)

func _fill_in_scoreboard() -> void:
	scoreboard.away_team = away_team
	scoreboard.home_team = home_team

# PRIVATE/HELPER
func _connect_signals() -> void:
	#court.connect("court_clicked", _on_court_clicked)
	for player in players_on_court:
		player.connect("player_clicked", _on_player_clicked)

func _flip_coin(team_1: Team, team_2: Team) -> Team:
	var teams = [team_1, team_2]
	var coin_toss_winner: Team = teams.pick_random()
	print_debug("%s won the coin toss" % coin_toss_winner.team_name)
	return coin_toss_winner

## RECEIVERS
func _on_player_clicked(clicked_player: Player) -> void:
	match clicked_player.select_state:
		Player.Selectability.SELECTABLE:
			print_debug("%s selected" % clicked_player.name)
			selected_player = clicked_player
			clicked_player.select_state = Player.Selectability.SELECTED
		Player.Selectability.SELECTED:
			print_debug("%s unselected" % clicked_player.name)
			selected_player = null
			clicked_player.select_state = Player.Selectability.SELECTABLE
		Player.Selectability.UNSELECTABLE:
			print_debug("%s cannot be selected right now" % clicked_player.name)

#func _on_court_clicked(click_position: Vector2i) -> void:
	#selected_player.target_cell = click_position
