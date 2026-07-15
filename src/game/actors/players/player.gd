@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

const MOVEMENT_SPEED: float = 10.0
const SELECTED_SCALE: float = 1.2
const TILE_SIZE: Vector2 = Vector2(48.0, 48.0)

signal player_clicked(this_player: Player)

enum Selectability {SELECTABLE, SELECTED, UNSELECTABLE}
enum PlayerSpeed {SLOW, AVERAGE, FAST}

@export_range(0, 99, 1) var player_number: int = 0
@export var player_speed: PlayerSpeed = PlayerSpeed.AVERAGE
@export_color_no_alpha var unselectable_modulate_color: Color = Color.GRAY

var movement_points_per_turn: float

var current_cell: Vector2i:
	set(value):
		current_cell = value
		snap_to_grid()

var court_map: CourtMap:
	set(value):
		court_map = value
		print_debug("%s has a reference to the CourtMap" % name)

var select_state: Selectability:
	set(value):
		select_state = value
		match select_state:
			Selectability.SELECTABLE:
				print_debug("%s is selectable" % name)
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = Color.WHITE
				player_light.visible = true
			Selectability.SELECTED:
				print_debug("%s is selected" % name)
				player_sprite.scale = Vector2.ONE * SELECTED_SCALE
				player_sprite.modulate = Color.WHITE
				court_map.highlight_movable_cells(self, current_cell, movement_points_per_turn)
			Selectability.UNSELECTABLE:
				print_debug("%s is unselectable" % name)
				player_sprite.scale = Vector2.ONE
				player_sprite.modulate = unselectable_modulate_color
				player_light.visible = false

@onready var player_number_label: Label = $PlayerNumberLabel
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var player_light: PointLight2D = $PlayerLight

func _ready() -> void:
	print_debug("%s ready" % name)
	_connect_signals()
	movement_points_per_turn = _set_movement_points(player_speed)
	player_number_label.text = str(player_number)

func snap_to_grid() -> void:
	var cell_position = court_map.map_to_local(current_cell)
	print_debug("Snapping %s to cell %s (position %s)" % [name, current_cell, cell_position])
	#var tile_size:= court_map.tile_set.tile_size
	position = cell_position

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
