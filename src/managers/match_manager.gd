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
		print_debug("%s has the ball" % possessing_team)

var selected_player: Player:
	set(value):
		selected_player = value
		print_debug("%s is the currently selected player" % selected_player.name)
		court.highlight_potential_moves(selected_player)

@onready var scoreboard: Scoreboard = %Scoreboard

func _ready() -> void:
	_connect_signals()
	print_debug("%s ready" % name)
	_fill_in_scoreboard()

func _fill_in_scoreboard() -> void:
	scoreboard.away_team = away_team
	scoreboard.home_team = home_team

# PRIVATE/HELPER
func _connect_signals() -> void:
	#court.connect("court_clicked", _on_court_clicked)
	for player in players_on_court:
		player.connect("player_clicked", _on_player_clicked)

## RECEIVERS
func _on_player_clicked(clicked_player: Player) -> void:
	print_debug("%s clicked" % clicked_player.name)
	match clicked_player.select_state:
		Player.Selectability.SELECTABLE:
			print_debug("You selected %s" % clicked_player.name)
			selected_player = clicked_player
			clicked_player.select_state = Player.Selectability.SELECTED
		Player.Selectability.SELECTED:
			print_debug("%s already selected" % clicked_player.name)
		Player.Selectability.UNSELECTABLE:
			print_debug("%s cannot be selected right now" % clicked_player.name)

#func _on_court_clicked(click_position: Vector2i) -> void:
	#selected_player.target_cell = click_position
