#@tool
@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

const MOVEMENT_SPEED: float = 10.0
const SELECTED_SCALE: float = 1.2
const TILE_SIZE: Vector2 = Vector2(48.0, 48.0)

signal player_clicked

enum Selectability {SELECTABLE, SELECTED, UNSELECTABLE}
enum PlayerSpeed {SLOW, AVERAGE, FAST}

@export var player_speed: PlayerSpeed = PlayerSpeed.AVERAGE

var movement_points_per_turn: float
var current_cell: Vector2i

var select_state: Selectability:
	set(value):
		select_state = value
		match select_state:
			Selectability.SELECTABLE:
				print_debug("%s is selectable" % name)
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = Color.WHITE
			Selectability.SELECTED:
				print_debug("%s is selected" % name)
				player_sprite.scale = Vector2.ONE * SELECTED_SCALE
				player_sprite.modulate = Color.WHITE
			Selectability.UNSELECTABLE:
				print_debug("%s is unselectable" % name)
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = Color.DIM_GRAY

@onready var player_sprite: Sprite2D = %PlayerSprite

func _ready() -> void:
	print_debug("%s ready" % name)
	_connect_signals()
	movement_points_per_turn = _set_movement_points(player_speed)
	#position = position.snapped(TILE_SIZE) + TILE_SIZE * Vector2(0.5, 0.35)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

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

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_clicked.emit(self)
		print_debug("%s clicked" % name)
