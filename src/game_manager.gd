@tool
#@icon(icon_path: String)
class_name Game
extends Node3D
## Game controller. Manages state, score and other game/match-level info.


@export_group("Team Info")
@export_subgroup("Home Team")
@export var home_team_name: String = "Homers"
@export var home_team_color: Color = Color.WHITE
@export_subgroup("Away Team")
@export var away_team_name: String = "Awayers"
@export var away_team_color: Color = Color.BLACK

@export_group("Game Info")
@export_subgroup("Score")
## The current score for the home team
@export var home_team_score: int = 0:
	set(value):
		if not is_node_ready():
			await ready
		game_ui.home_team_score_label.text = "%02d" % value
## The current score for the away team
@export var away_team_score: int = 0:
	set(value):
		if not is_node_ready():
			await ready
		game_ui.away_team_score_label.text = "%02d" % value

## The [Player] whose turn it currently is
var active_player: Player:
	set(value):
		if not is_node_ready():
			await ready
		active_player = value
		active_player.is_active = true
		court.connect("movement_target_moved", active_player.on_movement_target_moved)
		game_ui.active_player_name_label.text = active_player.name
		game_ui.update_active_player_label(turn_manager.current_index)

## The [Player]s in their current turn order
var current_turn_order: Array[Player]:
	set(value):
		current_turn_order = value
		game_ui.assign_turn_order_labels(current_turn_order)

## The Players on the home team
var home_team_players: Array[Node]
## The Players on the away team
var away_team_players: Array[Node]
## The Players on the court
var players_on_court: Array[Player] 

## Parent [Control] for all UI elements
@onready var game_ui: GameUI = %GameUI

## [Node] that manages Turn order and Round number (each Round is a sequence of Turns) #TODO: Make these classes
@onready var turn_manager: TurnManager = %TurnManager

## The Court node
@onready var court: StaticBody3D = %Court

func _ready() -> void:
	_connect_signals()
	_assign_players_to_teams()
	_reset_active_player()
	_set_initial_turn_order()


# PRIVATE/HELPER
func _assign_players_to_teams() -> void:
	home_team_players = get_tree().get_nodes_in_group("home_team")
	for player in home_team_players:
		print(player.name + " is on the home team")
		player.team_color = home_team_color
		players_on_court.append(player)
		print(player.name + " is on the court")

	away_team_players = get_tree().get_nodes_in_group("away_team")
	for player in away_team_players:
		print(player.name + " is on the away team")
		player.team_color = away_team_color
		players_on_court.append(player)
		print(player.name + " is on the court")


func _connect_signals() -> void:
	game_ui.connect("turn_ended", _on_turn_ended)
	turn_manager.connect("round_completed", _on_round_completed)

func _set_initial_turn_order() -> void:
	turn_manager.players_in_game = players_on_court
	current_turn_order = turn_manager.shuffle_players()
	print("Initial turn order set: %s" % str(current_turn_order))
	active_player = turn_manager.get_active_player()


func _on_turn_ended() -> void:
	print("GM ending turn for %s" % active_player.name)
	court.disconnect("movement_target_moved", active_player.on_movement_target_moved)
	active_player.is_active = false
	if turn_manager.current_index < players_on_court.size() - 1:
		turn_manager.current_index += 1 
	else:
		turn_manager.current_index = 0
		turn_manager.current_round += 1
	active_player = turn_manager.get_active_player()


func _on_round_completed() -> void:
	game_ui.round_number_label.text = "Round %s" % str(turn_manager.current_round)

func _reset_active_player() -> void:
	for player in players_on_court:
		player.is_active = false
