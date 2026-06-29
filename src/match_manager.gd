#@tool
@icon("uid://dnwrol7m3pe41")
class_name MatchManager
extends Node
## Manager class for an individual match/game. 

#signal
#enum
#const
@export var home_team: Team
@export var away_team: Team
#var
#@onready var
@onready var game_ui: GameUI = %GameUI

# OVERRIDES

func _ready() -> void:
	_connect_signals()
	_fill_in_scoreboard()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE
func _fill_in_scoreboard() -> void:
	await game_ui.ready
	game_ui.away_team_name.text = away_team.team_name_short
	game_ui.home_team_name.text = home_team.team_name_short
	game_ui.home_team_logo.texture = home_team.team_logo
	game_ui.away_team_logo.texture = away_team.team_logo

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
