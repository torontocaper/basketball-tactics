@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

signal energy_updated(new_energy : int)
#signal move_completed(energy_spent : int)
signal player_clicked(this_player : Player)

enum PlayerState {
	SELECTED,
	SELECTABLE,
	UNSELECTABLE,
	MOVING
}

const MOVEMENT_SPEED : float = 10.0
const SELECTED_SCALE : float = 1.2

@export_range(0, 99, 1) var player_number : int = 0 ## The Player's jersey number
@export_range(8, 16, 1.0) var player_base_energy : int = 10
@export var starting_coords : Vector2i

var available_energy : int:
	set(value):
		available_energy = value
		energy_updated.emit(available_energy)

var coords : Vector2i
var player_state : PlayerState:
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
var team : Team

@onready var player_number_label : Label = $PlayerNumberLabel
@onready var player_sprite : Sprite2D = $PlayerSprite
@onready var player_light : PointLight2D = $PlayerLight

func _ready() -> void:
	connect("input_event", _on_input_event)
	connect("player_clicked", TurnManager.on_player_clicked)
	#connect("move_completed", MoveManager.update_map)
	coords = starting_coords
	available_energy = player_base_energy
	player_number_label.text = str(player_number)

func move_along_path(path : Array, path_cost : int) -> Vector2:
	player_state = PlayerState.MOVING
	var movement_tween = create_tween()
	for point in path:
		movement_tween.tween_property(self, "global_position", point, 0.5)
		print_debug("New global position: %s" % str(global_position))
	available_energy -= path_cost
	await movement_tween.finished
	player_state = PlayerState.SELECTED
	return global_position

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_clicked.emit(self)
