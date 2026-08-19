#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

var is_active: bool = false:
	set(value):
		is_active = value

var team: Team:
	set(value):
		team = value
		print_debug("%s represents %s" % [name, team.name])

@onready var scoreboard: Scoreboard = %Scoreboard
@onready var active_team_label: Label = $HBoxContainer/ActiveTeamLabel
@onready var active_player_label: Label = $HBoxContainer/ActivePlayerLabel
@onready var active_player_energy: ProgressBar = $HBoxContainer/ActivePlayerEnergy

func _ready() -> void:
	print_debug("%s ready at %s ms" % [name, Time.get_ticks_msec()])
	active_player_label.text = ""
	active_team_label.text = ""
	TurnManager.connect("active_player_set", set_active_player)
	TurnManager.connect("active_team_set", set_active_team_label)

func set_active_player(active_player : Player) -> void:
	if active_player:
		active_player_label.text = active_player.name
		active_player_energy.max_value = active_player.player_base_energy
		active_player_energy.value = active_player.player_base_energy
		active_player.connect("move_completed", _update_energy_bar)
	else:
		active_player_label.text = ""

func set_active_team_label(active_team : Team) -> void:
	active_team_label.text = active_team.name

func _update_energy_bar(move_cost : int) -> void:
	active_player_energy.value -= move_cost
