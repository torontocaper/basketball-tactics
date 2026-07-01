#@tool
@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

const MOVEMENT_SPEED: float = 10.0

signal player_clicked
signal player_selected

enum Selectability {SELECTABLE, SELECTED, UNSELECTABLE}
enum PlayerSpeed {SLOW, AVERAGE, FAST}

@export var player_texture: Texture2D
@export var player_speed: PlayerSpeed = PlayerSpeed.AVERAGE

var movement_points_per_turn: float
var current_cell: Vector2i
var target_cell: Vector2i:
	set(value):
		target_cell = value
		print("%s has a target: %s" % [name, target_cell])

var select_state: Selectability:
	set(value):
		select_state = value
		match select_state:
			Selectability.SELECTABLE:
				print("%s is selectable" % name)
			Selectability.SELECTED:
				print("%s is selected" % name)
			Selectability.UNSELECTABLE:
				print("%s is unselectable" % name)

@onready var player_sprite: Sprite2D = %PlayerSprite

func _ready() -> void:
	_connect_signals()
	movement_points_per_turn = _set_movement_points(player_speed)
	player_sprite.texture = player_texture

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	connect("input_event", _on_input_event)

func _set_movement_points(value: PlayerSpeed) -> float:
	match value:
		PlayerSpeed.SLOW:
			return 3.0
		PlayerSpeed.AVERAGE:
			return 4.5
		PlayerSpeed.FAST:
			return 6.0
		_:
			return 4.5

# RECEIVERS
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_clicked.emit()
		print("%s clicked" % name)
		match select_state:
			Selectability.SELECTABLE:
				print("You selected %s" % name)
				player_selected.emit()
				select_state = Selectability.SELECTED
			Selectability.SELECTED:
				print("%s already selected" % name)
			Selectability.UNSELECTABLE:
				print("%s cannot be selected right now" % name)
