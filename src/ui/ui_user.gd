#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## UI scene for a particular User
## 
## Occupies half of the screen, and is rotated toward the User.
#region ENUMS
enum UserSide {
	HOME,
	AWAY
}
#endregion

#region PROPERTIES
#region Regular variables
## Which 'side' this user represents (ie: Home or Away)
@export var user_side : UserSide

## The [Team] controlled by the user assigned to this UI
var user_team: Team:
	set(value):
		if !value:
			user_team = null
			# no team assigned; reset border to white
			var new_panel : StyleBoxFlat = border.get_theme_stylebox("panel").duplicate()
			new_panel.border_color = Color.WHITE
			border.add_theme_stylebox_override("panel", new_panel)
		else:
			user_team = value
			# set border to team color
			var new_panel : StyleBoxFlat = border.get_theme_stylebox("panel").duplicate()
			new_panel.border_color = user_team.team_color
			border.add_theme_stylebox_override("panel", new_panel)
#endregion

#region Onready/child nodes
@onready var border: PanelContainer = %Border
@onready var game_controls: Control = %GameControls
@onready var team_list: ItemList = %TeamList
@onready var ready_button: Button = %ReadyButton
@onready var team_select: Control = %TeamSelect
@onready var team_select_title: Label = %TeamSelectTitle
@onready var scoreboard: Scoreboard = %Scoreboard
@onready var end_turn_button: Button = %EndTurnButton
@onready var button_box: HBoxContainer = %ButtonBox
@onready var player_box: PlayerBox = %PlayerBox
#endregion
#endregion

#region METHODS
#region Overrides
func _ready() -> void:
	# Hide the active game items 
	game_controls.hide()
	# Connect the game controls' visibility signal 
	game_controls.visibility_changed.connect(_on_game_controls_visibility_changed)
	# Set the label text to home/away
	team_select_title.text = "Select %s team:" % UserSide.keys()[user_side]
	# Clear out the team list
	team_list.clear()
	# Add the actual teams to the list
	for team in Teams.teams:
		team_list.add_item(team.name)
	# Disable the 'ready' button
	ready_button.disabled = true
	# Use the item_selected signal to choose a team for this user
	team_list.item_selected.connect(_on_team_list_item_selected)
#endregion

#region Core
func set_new_active_player_or_null(new_active_player : Player) -> void:
	# If this User isn't active, ignore
	if TurnManager.active_team != user_team:
		return
	# If there's no active player, hide the player UI
	elif !new_active_player:
		player_box.hide()
	# Otherwise, assign the new active player to the PlayerBox
	else:
		player_box.player = new_active_player
		player_box.show()

func set_new_active_team(new_active_team : Team) -> void:
	print_debug("Setting new active team on %s" % name)
	if new_active_team == user_team:
		button_box.show()
	else:
		button_box.hide()
		player_box.hide()
#endregion

#region Helpers
func _on_game_controls_visibility_changed() -> void:
	if game_controls.visible:
		set_new_active_player_or_null(null)
		TurnManager.active_player_set.connect(set_new_active_player_or_null)
		set_new_active_team(TurnManager.active_team)
		TurnManager.active_team_set.connect(set_new_active_team)
		end_turn_button.pressed.connect(TurnManager.end_turn)

func _on_team_list_item_selected(team_index : int) -> void:
	user_team = Teams.teams[team_index]
	ready_button.disabled = false
#endregion
#endregion
