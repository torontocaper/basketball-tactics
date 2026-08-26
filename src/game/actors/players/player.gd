@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

## Emitted when the player's energy level changes
signal energy_updated(new_energy : int)
## Emitted when the player is clicked (by a mouse or touch input)
signal player_clicked(this_player : Player)

## Possible states that the player can be in (only one may be active at a time)
enum PlayerState {
	SELECTED, ## The player is currently selected
	SELECTABLE, ## The player can be selected, but is not currently
	UNSELECTABLE, ## The player cannot currently be selected
	MOVING ## The player is in the process of moving
}

const MOVEMENT_SPEED : float = 10.0 ## Determines how fast the player sprite moves across the screen
const SELECTED_SCALE : float = 1.2 ## Determines how much to scale up the player sprite when this player is selected

@export_range(0, 99, 1) var player_number : int = 0 ## The player's jersey number
@export_range(8, 16, 1.0) var player_base_energy : int = 10 ## The player's base energy level per turn
@export var starting_coords : Vector2i ## The coordinates the player starts on

var available_energy : int: ## The energy remaining for the player in this turn. Reduced by moving and/or taking an action
	set(value):
		available_energy = value
		energy_updated.emit(available_energy)
var coords : Vector2i ## The coordinates where the player is currently located
var player_state : PlayerState: ## The state this player is currently in. Corresponds to one of the PlayerState enums
	set(value):
		player_state = value
		match player_state:
			PlayerState.SELECTED:
				player_sprite.scale = Vector2.ONE * SELECTED_SCALE
				player_sprite.modulate = Color.WHITE
				player_light.visible = true
			PlayerState.SELECTABLE:
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = Color.WHITE
				player_light.visible = false
			PlayerState.UNSELECTABLE:
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = Color.DIM_GRAY
				player_light.visible = false
			PlayerState.MOVING:
				player_sprite.scale = Vector2.ONE * SELECTED_SCALE
				player_sprite.modulate = Color.WHITE
				player_light.visible = true
				pass
			_:
				pass
var team : Team ## The [Team] this player belongs to

#region Child nodes
@onready var player_number_label : Label = $PlayerNumberLabel
@onready var player_sprite : Sprite2D = $PlayerSprite
@onready var player_light : PointLight2D = $PlayerLight
#endregion

func _ready() -> void:
	connect("input_event", _on_input_event)
	connect("player_clicked", TurnManager.on_player_clicked)
	coords = starting_coords
	available_energy = player_base_energy
	player_number_label.text = str(player_number)

## Currently called from [CourtLayerData]
func move_along_path(path : Array, path_cost : int) -> void:
	player_state = PlayerState.MOVING
	var movement_tween = create_tween()
	for point in path.slice(1): # Don't 'move' to the starting point
		print_debug("Moving to position %s" % str(point))
		movement_tween.tween_property(self, "global_position", point, 0.5)
		print_debug("New global position: %s" % str(global_position))
	print_debug("New global position: %s" % str(global_position))
	available_energy -= path_cost
	await movement_tween.finished
	player_state = PlayerState.SELECTED

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_clicked.emit(self)
