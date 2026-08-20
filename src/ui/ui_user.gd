#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

var active_player : Player
	#set(value):
		#if active_player:
			#if active_player.is_connected("energy_updated", _update_energy_bar):
				#active_player.disconnect("energy_updated", _update_energy_bar)
		#if !value:
			#active_player_label.text = ""
			#active_player_energy.z_index = -100
		#else:
			#active_player = value
			#active_player_label.text = active_player.name
			#active_player_energy.z_index = 10
			#active_player_energy.max_value = active_player.player_base_energy
			#active_player_energy.value = active_player.available_energy
			#active_player.connect("energy_updated", _update_energy_bar)

var is_user_active: bool = false:
	set(value):
		is_user_active = value

var user_team: Team:
	set(value):
		user_team = value
		print_debug("%s represents %s" % [name, user_team.name])

@onready var user_scoreboard: Scoreboard = %Scoreboard
@onready var active_team_label: Label = %ActiveTeamLabel
@onready var active_player_label: Label = %ActivePlayerLabel
@onready var active_player_energy: ProgressBar = %ActivePlayerEnergy

func _ready() -> void:
	print_debug("%s ready at %s ms" % [name, Time.get_ticks_msec()])
	active_player_label.text = ""
	active_team_label.text = ""
	TurnManager.connect("active_player_set", set_new_active_player_or_null)
	TurnManager.connect("active_team_set", set_active_team_label)

func set_new_active_player_or_null(new_active_player : Player) -> void:
	if active_player:
		if active_player.is_connected("energy_updated", _update_energy_bar):
			active_player.disconnect("energy_updated", _update_energy_bar)
	if !new_active_player:
		active_player_label.text = ""
		active_player_energy.modulate = Color.TRANSPARENT
	else:
		active_player = new_active_player
		active_player_label.text = active_player.name
		active_player_energy.modulate = Color.WHITE
		active_player_energy.max_value = active_player.player_base_energy
		active_player_energy.value = active_player.available_energy
		active_player.connect("energy_updated", _update_energy_bar)

func set_active_team_label(active_team : Team) -> void:
	active_team_label.text = active_team.name

func _update_energy_bar(new_energy : int) -> void:
	active_player_energy.value = new_energy
