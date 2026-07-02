#@tool
@icon("uid://3qwgg5y3fkjd")
class_name MatchManager
extends Node
## Manager class for an individual match/game. 

@export var court: Court

@export var away_team: Team
@export var home_team: Team

@export var selected_player: Player:
	set(value):
		selected_player = value
		print("%s is the currently selected player" % selected_player.name)

var away_team_score: int = 0:
	set(value):
		away_team_score = value
		scoreboard.away_team_score.text = "%02d" % away_team_score

var home_team_score: int = 0:
	set(value):
		home_team_score = value
		scoreboard.home_team_score.text = "%02d" % home_team_score

@onready var scoreboard: Scoreboard = %Scoreboard

func _ready() -> void:
	_connect_signals()
	_fill_in_scoreboard()

func _fill_in_scoreboard() -> void:
	scoreboard.away_team = away_team
	scoreboard.home_team = home_team

# PRIVATE/HELPER
func _connect_signals() -> void:
	court.connect("court_clicked", _on_court_clicked)

# RECEIVERS
func _on_court_clicked(click_position: Vector2i) -> void:
	selected_player.target_cell = click_position
