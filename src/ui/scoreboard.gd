#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

#region PROPERTIES
@export var home_team: Team:
	set(value):
		home_team = value
		home_score_label.add_theme_color_override("font_color", home_team.team_color)

@export var away_team: Team:
	set(value):
		away_team = value
		away_score_label.add_theme_color_override("font_color", away_team.team_color)

var current_game: Game:
	set(value):
		current_game = value
		home_team = current_game.home_team
		away_team = current_game.away_team
		current_game.connect("score_updated", update_scoreboard)

@onready var away_score_label: Label = %AwayTeamScore
@onready var home_score_label: Label = %HomeTeamScore
#endregion

#region METHODS
##region Overrides
#func _ready() -> void:
	#GameManager.game_updated
#region Core
func update_scoreboard(team : Team, new_score : int) -> void:
	match team:
		away_team:
			away_score_label.text = "%02d" % new_score
		home_team:
			home_score_label.text = "%02d" % new_score
		_:
			pass
#endregion
#endregion
