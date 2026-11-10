#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## UI scene for a particular User
## 
## Occupies half of the screen, and is rotated toward the User.

##region CONSTANTS
#const BLUE_BORDER = preload("uid://b7wsgjbmvcoy7") ## The green_border stylebox resource; assigned to the User controlling the blue team
#const GREEN_BORDER = preload("uid://baub6wgeedwof") ## The blue_border stylebox resource; assigned to the User controlling the green team
##endregion

#region PROPERTIES
#region Regular variables
## The [Team] controlled by the user assigned to this UI
var user_team: Team:
	set(value):
		user_team = value
		var new_panel = border.get_theme_stylebox("panel").duplicate()
		match user_team.name:
			"GreenTeam":
				new_panel.border_color = Color.GREEN
			"BlueTeam":
				new_panel.border_color = Color.BLUE
			"RedTeam":
				new_panel.border_color = Color.RED
			_:
				pass
		border.add_theme_stylebox_override("panel", new_panel)
#endregion

#region Onready/child nodes
@onready var border: PanelContainer = %Border
@onready var end_turn_button: Button = %EndTurnButton
@onready var button_box: HBoxContainer = %ButtonBox
@onready var player_box: PlayerBox = %PlayerBox
@onready var scoreboard_box: CenterContainer = %ScoreboardBox
#endregion
#endregion

#region METHODS
#region Overrides
func _ready() -> void:
	# Hide the active game items 
	player_box.hide()
	button_box.hide()
	scoreboard_box.hide()
	#CAUTION: don't delete; refactor below code to happen after team selection
	#set_new_active_player_or_null(null)
	#TurnManager.active_player_set.connect(set_new_active_player_or_null)
	#set_new_active_team(TurnManager.active_team)
	#TurnManager.active_team_set.connect(set_new_active_team)
	#end_turn_button.pressed.connect(TurnManager.end_turn)
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
#endregion
