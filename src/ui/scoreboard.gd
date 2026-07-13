#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

@export var away_team: Team:
	set(value):
		away_team = value
		print_debug("Scoreboard has an away team: %s" % away_team.team_name)

@export var home_team: Team:
	set(value):
		home_team = value
		print_debug("Scoreboard has an away team: %s" % home_team.team_name)

@export var current_game: Game:
	set(value):
		current_game = value
		away_team = current_game.away_team
		home_team = current_game.home_team
		current_game.connect("score_updated", update_scoreboard)

@onready var away_score_label: Label = %AwayTeamScore
@onready var home_score_label: Label = %HomeTeamScore

func _ready() -> void:
	print_debug("Scoreboard ready at %s ms" % Time.get_ticks_msec())

func update_scoreboard(away_team_score: int, home_team_score:int) -> void:
	away_score_label.text = "%02d" % away_team_score
	home_score_label.text = "%02d" % home_team_score
