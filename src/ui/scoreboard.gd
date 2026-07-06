#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

@export var away_team: Team:
	set(value):
		away_team = value
		away_team_name.text = away_team.team_name_short
		away_team_logo.texture = away_team.team_logo

@export var home_team: Team:
	set(value):
		home_team = value
		home_team_name.text = home_team.team_name_short
		home_team_logo.texture = home_team.team_logo

@export var possessing_team: Team:
	set(value):
		possessing_team = value
		match possessing_team:
			away_team:
				away_possession_indicator.visible = true
				home_possession_indicator.visible = false
			home_team:
				away_possession_indicator.visible = false
				home_possession_indicator.visible = true
			_:
				away_possession_indicator.visible = false
				home_possession_indicator.visible = false


@onready var away_possession_indicator: TextureRect = %AwayPossessionIndicator
## [TextureRect] that displays the visiting [Team]'s logo
@onready var away_team_logo: TextureRect = %AwayTeamLogo
## [Label] that displays the visiting [Team]'s name
@onready var away_team_name: Label = %AwayTeamName
## [Label] that displays the visiting [Team]'s score
@onready var away_team_score: Label = %AwayTeamScore

@onready var home_possession_indicator: TextureRect = %HomePossessionIndicator
## [TextureRect] that displays the home [Team]'s logo
@onready var home_team_logo: TextureRect = %HomeTeamLogo
## [Label] that displays the home [Team]'s name
@onready var home_team_name: Label = %HomeTeamName
## [Label] that displays the home [Team]'s score
@onready var home_team_score: Label = %HomeTeamScore

func _ready() -> void:
	print_debug("Scoreboard ready")
