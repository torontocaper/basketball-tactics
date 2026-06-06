@tool
#@icon(icon_path: String)
class_name GameUI
extends Control
## User Interface for main [Game] scene. Displays score, turn order and other game-level information.

signal turn_ended
#enum
const ACTIVE_LABEL_STYLE_BOX: StyleBox = preload("uid://dm1d38j24xjio")

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

func _ready() -> void:
	_connect_signals()

## Assign Player names to the [member Label.text] property of each child of [member turn_order_labels]
func assign_turn_order_labels(current_turn_order: Array[Player]) -> void:
	for player in current_turn_order:
		var current_label = turn_order_labels.get_child(current_turn_order.find(player))
		current_label.text = player.name

## Highlight the [Label] representing the currently active [Player]
func update_active_player_label(current_turn_index: int) -> void:
	for label in turn_order_labels.get_children():
		label.remove_theme_stylebox_override("normal")
	var target_label = turn_order_labels.get_child(current_turn_index) as Label
	target_label.add_theme_stylebox_override("normal", ACTIVE_LABEL_STYLE_BOX)

# PRIVATE/HELPER
func _connect_signals() -> void:
	end_turn_button.connect("pressed", _on_end_turn_button_pressed)


# RECEIVERS
func _on_end_turn_button_pressed() -> void:
	turn_ended.emit()
# SETTERS/GETTERS
