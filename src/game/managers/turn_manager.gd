@icon("uid://hb3h3lrd8n4x")
class_name TurnManager
extends Node
## Turn controller.

@export var green_team: Team:
	set(value):
		green_team = value
		for player in green_team.players:
			player.connect("player_clicked", on_player_clicked)

@export var blue_team: Team:
	set(value):
		blue_team = value
		for player in blue_team.players:
			player.connect("player_clicked", on_player_clicked)

@export var selected_player: Player:
	set(value):
		if selected_player: # If there's already a selected player, unselect them (make them selectable again)
			selected_player.select_state = Player.Selectability.SELECTABLE
		if value:
			selected_player = value
			print_debug("%s is the currently selected player" % selected_player.name)
		else:
			print_debug("No player selected")

func _ready() -> void:
	print_debug("TurnManager ready at %s ms" % Time.get_ticks_msec())

func flip_coin(team_1: Team, team_2: Team) -> Array[Team]:
	var team_array: Array[Team] = [team_1, team_2]
	var winning_team: Team = team_array.pick_random()
	var losing_team: Team
	match winning_team:
		team_1:
			losing_team = team_2
		team_2:
			losing_team = team_1
	return [winning_team, losing_team]

func on_player_clicked(clicked_player: Player) -> void:
	match clicked_player.select_state:
		Player.Selectability.SELECTABLE:
			print_debug("%s selected" % clicked_player.name)
			selected_player = clicked_player
			clicked_player.select_state = Player.Selectability.SELECTED
		Player.Selectability.SELECTED:
			print_debug("%s unselected" % clicked_player.name)
			selected_player = null
			clicked_player.select_state = Player.Selectability.SELECTABLE
		Player.Selectability.UNSELECTABLE:
			print_debug("%s cannot be selected right now" % clicked_player.name)

func end_turn(team: Team) -> void:
	team.is_active = false

func start_turn(team: Team) -> void:
	team.is_active = true
