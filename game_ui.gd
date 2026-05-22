#@tool
#@icon(icon_path: String)
class_name GameUI
extends Control
## User Interface for main [Game] scene. Displays score, turn order and other game-level information.

#signal
#enum
#const
#@export var
#var
## Label that specifies which [Player] is currently active
@onready var active_player_name_label: Label = %ActivePlayerNameLabel
## Label that displays the visiting Team's name
@onready var away_team_name_label: Label = %AwayTeamNameLabel
## Label that displays the visiting Team's score
@onready var away_team_score_label: Label = %AwayTeamScoreLabel
## Label that displays the home Team's name
@onready var home_team_name_label: Label = %HomeTeamNameLabel
## Label that displays the home Team's score
@onready var home_team_score_label: Label = %HomeTeamScoreLabel
## Button that ends the [Player]'s turn
@onready var end_turn_button: Button = %EndTurnButton
## [Label] that displays the Round number (a Round is a full sequence of Turns) #TODO: Make these classes
@onready var round_number_label: Label = %RoundNumberLabel
## [VBoxContainer] containing [Label]s representing each [Player] in the [Turn] sequence
@onready var turn_order_labels: VBoxContainer = %TurnOrderLabels


# OVERRIDES

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
