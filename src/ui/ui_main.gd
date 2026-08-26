class_name UIMain
extends Control

#region Properties
var green_team: Team:
	set(value):
		green_team = value
		ui_user_north.user_team = green_team

var blue_team: Team:
	set(value):
		blue_team = value
		ui_user_south.user_team = blue_team

@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth
#endregion

#region Methods
func _ready():
	print_debug("UIMain ready at %s ms" % Time.get_ticks_msec())
	var main : Main = get_tree().current_scene
	var game : Game = main.game
	game.start_game()
	green_team = game.green_team
	blue_team = game.blue_team
	var user_uis: Array[UIUser] = [ui_user_north, ui_user_south]
	for user_ui in user_uis:
		user_ui.user_scoreboard.current_game = game
#endregion
