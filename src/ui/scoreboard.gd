#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

@export var away_team: Team
@export var home_team: Team

@onready var away_team_score: Label = %AwayTeamScore
@onready var home_team_score: Label = %HomeTeamScore

func _ready() -> void:
	print_debug("Scoreboard ready at %s ms" % Time.get_ticks_msec())
