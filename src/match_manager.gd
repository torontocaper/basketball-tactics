#@tool
@icon("uid://dnwrol7m3pe41")
class_name MatchManager
extends Node
## Manager class for an individual match/game. 

@export var home_team: Team
@export var away_team: Team

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
	pass

# RECEIVERS
