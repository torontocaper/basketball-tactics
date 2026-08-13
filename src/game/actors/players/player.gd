@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

signal player_clicked(this_player: Player)

enum PlayerSpeed {
	SLOW = 6,
	AVERAGE = 9, 
	FAST = 12
	}

const MOVEMENT_SPEED: float = 10.0
const SELECTED_SCALE: float = 1.2

@export_range(0, 99, 1) var player_number : int = 0
@export var player_speed : PlayerSpeed = PlayerSpeed.AVERAGE
@export var starting_coords : Vector2i

var coords : Vector2i
var is_selectable: bool:
	set(value):
		is_selectable = value
		if is_selectable:
			player_sprite.scale = Vector2.ONE
			player_sprite.modulate = Color.WHITE
			player_light.visible = false
		else:
			player_sprite.scale = Vector2.ONE
			player_sprite.modulate = Color.GRAY
			player_light.visible = false
var is_selected: bool:
	set(value):
		is_selected = value
		if is_selected:
			is_selectable = false
			player_sprite.scale = Vector2.ONE * SELECTED_SCALE
			player_sprite.modulate = Color.WHITE
			player_light.visible = true
		else:
			is_selectable = true
var team : Team

@onready var player_number_label: Label = $PlayerNumberLabel
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var player_light: PointLight2D = $PlayerLight

func _ready() -> void:
	connect("input_event", _on_input_event)
	player_number_label.text = str(player_number)
	coords = starting_coords

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_clicked.emit(self)
