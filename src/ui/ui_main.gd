class_name UIMain
extends Control

var current_game: Game

var green_team: Team:
	set(value):
		green_team = value
		print_debug("UIMain has a green team: %s" % green_team.team_name)
		ui_user_north.team = green_team

var blue_team: Team:
	set(value):
		blue_team = value
		print_debug("UIMain has a blue team: %s" % blue_team.team_name)
		ui_user_south.team = blue_team

@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth

func _ready():
	print_debug("UIMain ready at %s ms" % Time.get_ticks_msec())
	var ui_parent = get_parent() as UI
	current_game = ui_parent.game
	current_game.start_game()
	green_team = current_game.green_team
	blue_team = current_game.blue_team
	var user_uis: Array[UIUser] = [ui_user_north, ui_user_south]
	for ui in user_uis:
		ui.scoreboard.current_game = current_game
