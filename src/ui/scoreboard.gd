#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

@export var green_team: Team:
	set(value):
		green_team = value
		print_debug("Scoreboard has a green team: %s" % green_team.team_name)

@export var blue_team: Team:
	set(value):
		blue_team = value
		print_debug("Scoreboard has a blue team: %s" % blue_team.team_name)

@export var current_game: Game:
	set(value):
		current_game = value
		green_team = current_game.green_team
		blue_team = current_game.blue_team
		current_game.connect("score_updated", update_scoreboard)

@onready var green_score_label: Label = %GreenTeamScore
@onready var blue_score_label: Label = %BlueTeamScore

func _ready() -> void:
	print_debug("Scoreboard ready at %s ms" % Time.get_ticks_msec())

func update_scoreboard(green_team_score: int, blue_team_score:int) -> void:
	green_score_label.text = "%02d" % green_team_score
	blue_score_label.text = "%02d" % blue_team_score
