class_name UIMain
extends Control

var current_game: Game

var away_team: Team:
	set(value):
		away_team = value
		print_debug("UIMain has a(n) away team: %s" % away_team.team_name)
var home_team: Team:
	set(value):
		home_team = value
		print_debug("UIMain has a(n) home team: %s" % home_team.team_name)

@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("UIMain ready at %s ms" % Time.get_ticks_msec())
	var parent_ui = get_parent() as UI
	current_game = parent_ui.game
	current_game.start_game()
	away_team = current_game.away_team
	home_team = current_game.home_team
	var user_uis: Array[UIUser] = [ui_user_north, ui_user_south]
	for ui in user_uis:
		ui.scoreboard.current_game = current_game
