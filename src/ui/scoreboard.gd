#@tool
@icon("uid://dnwrol7m3pe41")
class_name Scoreboard
extends PanelContainer
## Displays the score.

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
