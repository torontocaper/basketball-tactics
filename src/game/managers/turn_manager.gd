#@tool
@icon("uid://hb3h3lrd8n4x")
class_name TurnManager
extends Node
### Turn controller.

@export var away_team: Team:
	set(value):
		away_team = value
		away_team_players = away_team.players

@export var home_team: Team:
	set(value):
		home_team = value
		home_team_players = home_team.players

@export var possessing_team: Team:
	set(value):
		possessing_team = value
		match possessing_team:
			away_team:
				for player in home_team_players:
					player.select_state = Player.Selectability.UNSELECTABLE
			home_team:
				for player in away_team_players:
					player.select_state = Player.Selectability.UNSELECTABLE

@export var selected_player: Player:
	set(value):
		if selected_player: # If there's already a selected player, unselect them (make them selectable again)
			selected_player.select_state = Player.Selectability.SELECTABLE
		if value:
			selected_player = value
			print_debug("%s is the currently selected player" % selected_player.name)
		else:
			print_debug("No player selected")

var away_team_players: Array[Player]:
	set(value):
		away_team_players = value
		for player in away_team_players:
			player.connect("player_clicked", on_player_clicked)

var home_team_players: Array[Player]:
	set(value):
		home_team_players = value
		for player in home_team_players:
			player.connect("player_clicked", on_player_clicked)

func _ready() -> void:
	print_debug("TurnManager ready at %s ms" % Time.get_ticks_msec())

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
