#@tool
#@icon(icon_path: String)
class_name Game
extends Node3D
## Documentation comments

#signal
#enum
#const
@export var home_team_name: String = "Homers"
@export var home_team_color: Color = Color.WHITE
@export var away_team_name: String = "Awayers"
@export var away_team_color: Color = Color.BLACK

var home_team_players: Array[Node]
var away_team_players: Array[Node]
#@onready var

# OVERRIDES

func _ready() -> void:
	home_team_players = get_tree().get_nodes_in_group("home_team")
	away_team_players = get_tree().get_nodes_in_group("away_team")
	for player in home_team_players:
		print(player.name + " is on the home team")
		player.team_color = home_team_color
	for player in away_team_players:
		print(player.name + " is on the away team")
		player.team_color = away_team_color

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER

# RECEIVERS

# SETTERS/GETTERS
