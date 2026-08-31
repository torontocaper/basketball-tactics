#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

#region Constants
const BLUE_BORDER = preload("uid://b7wsgjbmvcoy7")
const GREEN_BORDER = preload("uid://baub6wgeedwof")
#endregion

#region Properties
var active_player : Player

var is_user_active: bool = false:
	set(value):
		is_user_active = value

## The [Team] controlled by the user assigned to this UI
var user_team: Team:
	set(value):
		user_team = value
		match user_team.name:
			"GreenTeam":
				border.add_theme_stylebox_override("panel", GREEN_BORDER)
			"BlueTeam":
				border.add_theme_stylebox_override("panel", BLUE_BORDER)
			_:
				pass

@onready var border: PanelContainer = %Border
@onready var user_scoreboard: Scoreboard = %Scoreboard
#@onready var active_team_label: Label = %ActiveTeamLabel
@onready var active_player_label: Label = %ActivePlayerLabel
@onready var active_player_energy: ProgressBar = %ActivePlayerEnergy
#endregion

#region Methods
	#region Overrides
func _ready() -> void:
	active_player_label.text = ""
	#active_team_label.text = ""
	TurnManager.connect("active_player_set", set_new_active_player_or_null)
	#TurnManager.connect("active_team_set", set_active_team_label)
	#endregion

	#region Core
func set_new_active_player_or_null(new_active_player : Player) -> void:
	if active_player:
		if active_player.is_connected("energy_updated", _update_energy_bar):
			active_player.disconnect("energy_updated", _update_energy_bar)
	if !new_active_player:
		active_player_label.text = ""
		active_player_energy.modulate = Color.TRANSPARENT
	else:
		active_player = new_active_player
		active_player_label.text = active_player.name
		active_player_energy.modulate = Color.WHITE
		active_player_energy.max_value = active_player.player_base_energy
		active_player_energy.value = active_player.available_energy
		active_player.connect("energy_updated", _update_energy_bar)

#func set_active_team_label(active_team : Team) -> void:
	#active_team_label.text = active_team.name
	#endregion

	#region Private/Helper
func _update_energy_bar(new_energy : int) -> void:
	active_player_energy.value = new_energy
	#endregion
#endregion
