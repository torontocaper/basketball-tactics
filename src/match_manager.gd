#@tool
@icon("uid://3qwgg5y3fkjd")
class_name MatchManager
extends Node
## Manager class for an individual match/game. 

@export var court: Court

@export var home_team: Team
@export var away_team: Team
@export var home_team_score: int = 0:
	set(value):
		home_team_score = value
		scoreboard.home_team_score.text = "%02d" % home_team_score
@export var away_team_score: int = 0:
	set(value):
		away_team_score = value
		scoreboard.away_team_score.text = "%02d" % away_team_score

var selected_player: Player:
	set(value):
		selected_player = value
		print("%s is the currently selected player" % selected_player.name)

@onready var scoreboard: Scoreboard = %Scoreboard

func _ready() -> void:
	_connect_signals()
	_fill_in_scoreboard()

func _fill_in_scoreboard() -> void:
	await scoreboard.ready
	scoreboard.away_team_name.text = away_team.team_name_short
	scoreboard.home_team_name.text = home_team.team_name_short
	scoreboard.home_team_logo.texture = home_team.team_logo
	scoreboard.away_team_logo.texture = away_team.team_logo

# PRIVATE/HELPER
func _connect_signals() -> void:
	court.connect("court_clicked", _on_court_clicked)

# RECEIVERS
func _on_court_clicked(click_position: Vector2) -> void:
	selected_player.movement_target = click_position
