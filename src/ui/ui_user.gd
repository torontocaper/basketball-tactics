#@tool
#@icon(icon_path: String)
class_name UIUser
extends Control
## Documentation comments

var is_active: bool = false:
	set(value):
		is_active = value

var team: Team:
	set(value):
		team = value
		print_debug("%s represents %s" % [name, team.team_name])

@onready var scoreboard: Scoreboard = $Scoreboard

func _ready() -> void:
	print_debug("%s ready at %s ms" % [name, Time.get_ticks_msec()])
