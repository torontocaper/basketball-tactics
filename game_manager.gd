#@tool
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
@export var home_team_score: int = 0:
	set(h_t_s):
		if not is_node_ready():
			await ready
		game_ui.home_team_score_label.text = "%02d" % h_t_s
@export var away_team_score: int = 0:
	set(a_t_s):
		if not is_node_ready():
			await ready
		game_ui.away_team_score_label.text = "%02d" % a_t_s

var active_player: Player:
	set(a_p):
		if not is_node_ready():
			await ready
		print("GM making %s active" % a_p.name)
		active_player = a_p
		active_player.is_active = true
		game_ui.active_player_name_label.text = active_player.name
		game_ui.update_active_player_label(turn_manager.current_index)

var current_turn_order: Array[Player]:
	set(c_t_o):
		current_turn_order = c_t_o
		game_ui.assign_turn_order_labels(current_turn_order)
var home_team_players: Array[Node]
var away_team_players: Array[Node]
var players_on_court: Array[Player] 

## Parent [Control] for all UI elements
@onready var game_ui: GameUI = %GameUI

@onready var end_turn_button: Button = %EndTurnButton

## [Node] that manages Turn order and Round number (each Round is a sequence of Turns) #TODO: Make these classes
@onready var turn_manager: TurnManager = %TurnManager


func _ready() -> void:
	_connect_signals()
	_assign_players_to_teams()
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
	end_turn_button.connect("pressed", _on_end_turn_button_pressed)
	turn_manager.connect("round_completed", _on_round_completed)


func _set_initial_turn_order() -> void:
	turn_manager.players_in_game = players_on_court
	current_turn_order = turn_manager.shuffle_players()
	print("Initial turn order set: %s" % str(current_turn_order))
	active_player = turn_manager.get_active_player()


# RECEIVERS
func _on_end_turn_button_pressed() -> void:
	print("GM ending turn for %s" % active_player.name)
	active_player.is_active = false
	if turn_manager.current_index < players_on_court.size() - 1:
		turn_manager.current_index += 1 
	else:
		turn_manager.current_index = 0
		turn_manager.current_round += 1
	active_player = turn_manager.get_active_player()


func _on_round_completed() -> void:
	game_ui.round_number_label.text = "Round %s" % str(turn_manager.current_round)
