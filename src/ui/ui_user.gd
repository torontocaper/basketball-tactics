#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

#region Constants
const BLUE_BORDER = preload("uid://b7wsgjbmvcoy7") ## The green_border stylebox resource
const GREEN_BORDER = preload("uid://baub6wgeedwof") ## The blue_border stylebox resource
#endregion

#region Properties
#region Regular variables
var active_player : Player

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
#endregion

#region Onready/child Nodes
@onready var active_player_energy: ProgressBar = %ActivePlayerEnergy
@onready var active_player_label: Label = %ActivePlayerLabel
@onready var border: PanelContainer = %Border
@onready var end_turn_button: Button = %EndTurnButton
@onready var user_scoreboard: Scoreboard = %Scoreboard
@onready var player_box: HBoxContainer = %PlayerBox
@onready var button_box: HBoxContainer = %ButtonBox
#endregion
#endregion

#region Methods
#region Overrides
func _ready() -> void:
	await get_parent().ready
	player_box.hide()
	set_new_active_player_or_null(null)
	TurnManager.active_player_set.connect(set_new_active_player_or_null)
	set_new_active_team(TurnManager.active_team)
	TurnManager.active_team_set.connect(set_new_active_team)
	end_turn_button.pressed.connect(TurnManager.end_turn)
#endregion

#region Core
func set_new_active_player_or_null(new_active_player : Player) -> void:
	if TurnManager.active_team != user_team:
		return
	if active_player:
		if active_player.is_connected("energy_updated", _update_energy_bar):
			active_player.disconnect("energy_updated", _update_energy_bar)
	if !new_active_player:
		player_box.hide()
	else:
		active_player = new_active_player
		active_player_label.text = active_player.name
		player_box.show()
		active_player_energy.max_value = active_player.player_base_energy
		active_player_energy.value = active_player.available_energy
		active_player.connect("energy_updated", _update_energy_bar)

func set_new_active_team(new_active_team : Team) -> void:
	print_debug("Setting new active team on %s" % name)
	if new_active_team == user_team:
		button_box.show()
	else:
		button_box.hide()
		player_box.hide()
#endregion

#region Private/Helper
func _update_energy_bar(new_energy : int) -> void:
	active_player_energy.value = new_energy
#endregion
#endregion
