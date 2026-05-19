#@tool
#@icon(icon_path: String)
class_name Game
extends Node3D
## Documentation comments

#signal
#enum
#const
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
		home_team_score_label.text = "%02d" % h_t_s
@export var away_team_score: int = 0:
	set(a_t_s):
		if not is_node_ready():
			await ready
		away_team_score_label.text = "%02d" % a_t_s

@export_group("Turn Order")
@export var active_player: Player: #TODO: does this logic belong here or in TurnManager?
	set(a_p):
		if not is_node_ready():
			await ready
		print("Making %s active" % a_p.name)
		active_player = a_p
		active_player.is_active = true
		active_player_name_label.text = active_player.name


var home_team_players: Array[Node]
var away_team_players: Array[Node]
var players_on_court: Array[Player] #TODO: similarly, does this belong in TurnManager?


@onready var active_player_name_label: Label = %ActivePlayerNameLabel
@onready var away_team_name_label: Label = %AwayTeamNameLabel
@onready var away_team_score_label: Label = %AwayTeamScoreLabel
@onready var home_team_name_label: Label = %HomeTeamNameLabel
@onready var home_team_score_label: Label = %HomeTeamScoreLabel
@onready var end_turn_button: Button = %EndTurnButton
@onready var turn_manager: TurnManager = %TurnManager


func _ready() -> void:
	_connect_signals()
	home_team_players = get_tree().get_nodes_in_group("home_team")
	away_team_players = get_tree().get_nodes_in_group("away_team")
	for player in home_team_players:
		print(player.name + " is on the home team")
		player.team_color = home_team_color
		players_on_court.append(player)
		print(player.name + " is on the court")

	for player in away_team_players:
		print(player.name + " is on the away team")
		player.team_color = away_team_color
		players_on_court.append(player)
		print(player.name + " is on the court")

	print("There are %s players on the court" % [players_on_court.size()])

	active_player = turn_manager.shuffle_players(players_on_court)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	end_turn_button.connect("pressed", on_end_turn_button_pressed)


# RECEIVERS
func on_end_turn_button_pressed() -> void:
	#print("Ending turn")
	print("Ending turn for %s" % active_player.name)
