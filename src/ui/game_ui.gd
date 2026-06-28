@tool
#@icon(icon_path: String)
class_name GameUI
extends Control
## User Interface for main [Game] scene. Displays score, turn order and other game-level information.

signal turn_ended
#enum

#@export var
#var
## Label that specifies which [Player] is currently active
@onready var active_player_name: Label = %ActivePlayerName
## [TextureRect] representing the active [Player]
@onready var active_player_avatar: TextureRect = %ActivePlayerAvatar
## [Label] that displays the visiting Team's name
@onready var away_team_name: Label = %AwayTeamName
## [Label] that displays the visiting Team's score
@onready var away_team_score: Label = %AwayTeamScore
## [Label] that displays the home Team's name
@onready var home_team_name: Label = %HomeTeamName
## [Label] that displays the home Team's score
@onready var home_team_score: Label = %HomeTeamScore
## [Button] that ends the [Player]'s turn
@onready var end_turn_button: Button = %EndTurnButton
## [Label] that displays the Round number (a Round is a full sequence of Turns) #TODO: Make these classes
#@onready var round_number_label: Label = %RoundNumberLabel

@onready var start_button: Button = $UIMargin/StartButton

func _ready() -> void:
	_connect_signals()

# PRIVATE/HELPER
func _connect_signals() -> void:
	end_turn_button.connect("pressed", _on_end_turn_button_pressed)
	start_button.connect("pressed", _on_start_button_pressed)

# RECEIVERS
func _on_end_turn_button_pressed() -> void:
	turn_ended.emit()

func _on_start_button_pressed() -> void:
	start_button.queue_free()
