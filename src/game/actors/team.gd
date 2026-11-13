@icon("uid://by1gybw2wgs33")
class_name Team
extends Node2D
## Base class for teams

#region SIGNALS
signal team_state_changed(new_state : TeamState)
#endregion

#region ENUMS
enum TeamState {
	ACTIVE,
	INACTIVE
}
#endregion

#region PROPERTIES
## The team's primary color
@export var team_color : Color

## The [Player]s on this team
var players : Array[Player]

## The team's current state. One of the TeamState enums
var team_state : TeamState:
	set(value):
		team_state = value
		match team_state:
			TeamState.ACTIVE:
				for player in players:
					player.player_state = Player.PlayerState.SELECTABLE
			TeamState.INACTIVE:
				for player in players:
					player.player_state = Player.PlayerState.UNSELECTABLE
			_:
				pass
		team_state_changed.emit(team_state)
#endregion

#region Methods
	#region Overrides
func _ready() -> void:
	players = _get_players()
	#endregion

	#region Private/Helper
## Assign [Player]s to this [Team], and vice-versa
func _get_players() -> Array[Player]:
	var player_array : Array[Player]
	var player_nodes = get_children()
	for node in player_nodes:
		var player : Player = node
		player_array.append(player)
		player.team = self
	return player_array
	#endregion
#endregion
