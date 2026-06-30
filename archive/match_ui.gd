#@tool
#@icon(icon_path: String)
class_name MatchUI
extends Control
## User Interface for main [Game] scene. Displays score, turn order and other game-level information.

## [TextureRect] that displays the visiting [Team]'s logo
@onready var away_team_logo: TextureRect = %AwayTeamLogo
## [Label] that displays the visiting [Team]'s name
@onready var away_team_name: Label = %AwayTeamName
## [Label] that displays the visiting [Team]'s score
@onready var away_team_score: Label = %AwayTeamScore

## [TextureRect] that displays the home [Team]'s logo
@onready var home_team_logo: TextureRect = %HomeTeamLogo
## [Label] that displays the home [Team]'s name
@onready var home_team_name: Label = %HomeTeamName
## [Label] that displays the home [Team]'s score
@onready var home_team_score: Label = %HomeTeamScore

func _ready() -> void:
	_connect_signals()

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass
