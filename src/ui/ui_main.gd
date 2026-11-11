class_name UIMain
extends Control

#region Properties
@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth

var user_uis : Array[UIUser]
#endregion

func _ready() -> void:
	user_uis = [
		ui_user_north,
		ui_user_south
	]
	for ui in user_uis:
		ui.ready_button.connect("toggled", _attempt_to_start_game)

func _attempt_to_start_game(_is_toggled : bool) -> void:
	if ui_user_north.ready_button.button_pressed and ui_user_south.ready_button.button_pressed:
		print_debug("Both teams are ready to start!")
		if ui_user_north.user_team == ui_user_south.user_team:
			print_debug("Too bad you both have the same team selected. Try again!")
			for ui in user_uis:
				ui.ready_button.button_pressed = false
				ui.team_list.deselect_all()
				ui.user_team = null
		else:
			GameManager.set_up_game(ui_user_south.user_team, ui_user_north.user_team)
			for ui in user_uis:
				ui.team_select.hide()
				ui.game_controls.show()
				ui.scoreboard.home_team = ui_user_south.user_team
				ui.scoreboard.away_team = ui_user_north.user_team
