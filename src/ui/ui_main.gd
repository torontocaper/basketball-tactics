class_name UIMain
extends Control

#region PROPERTIES
@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth

var user_uis : Array[UIUser]
#endregion

#region METHODS
func _ready() -> void:
	user_uis = [
		ui_user_north,
		ui_user_south
	]
	for ui in user_uis:
		ui.ready_button.connect("toggled", _attempt_to_start_game)

func _attempt_to_start_game(_is_toggled : bool) -> void:
	# if both users have indicated that they're ready...
	if ui_user_north.ready_button.button_pressed and ui_user_south.ready_button.button_pressed:
		print_debug("Both teams are ready to start!")
		# if they've picked the same team, reset everything
		if ui_user_north.user_team == ui_user_south.user_team:
			print_debug("Too bad you both have the same team selected. Try again!")
			for ui in user_uis:
				ui.ready_button.button_pressed = false
				ui.ready_button.disabled = true
				ui.team_list.deselect_all()
				ui.user_team = null
		else:
			# set up a new game with the selected teams
			GameManager.set_up_game(ui_user_south.user_team, ui_user_north.user_team)
			# set up the UIs for the game
			for ui in user_uis:
				ui.team_select.hide()
				ui.game_controls.show()
				ui.scoreboard.home_team = ui_user_south.user_team
				ui.scoreboard.away_team = ui_user_north.user_team
#endregion
