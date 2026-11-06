class_name PlayerBox
extends HBoxContainer
## Container for [Player]-related UI elements (e.g. name, energy)
## 
## Assigned by [TurnManager] via [UIUser]

## The [Player] currently assigned to this UI element
var player : Player:
	set(value):
		# If there's already a player assigned to this Box, and the player's energy_updated signal is connected, disconnect it
		if player:
			if player.energy_updated.is_connected(_update_energy_bar):
				player.energy_updated.disconnect(_update_energy_bar)
		player = value
		# Update the UI with the starting info (player name, base energy, available energy)
		player_label.text = player.name
		player_energy.max_value = player.player_base_energy
		player_energy.value = player.available_energy
		# Connect the player's energy_update signal
		player.energy_updated.connect(_update_energy_bar)

@onready var player_label: Label = %PlayerLabel
@onready var player_energy: ProgressBar = %PlayerEnergy

func _update_energy_bar(new_energy : int) -> void:
	player_energy.value = new_energy
