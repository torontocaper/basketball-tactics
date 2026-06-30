#@tool
@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

signal player_clicked
signal player_selected
enum Selectability {SELECTABLE, SELECTED, UNSELECTABLE}
#const
@export var player_texture: Texture2D
@export var movement_speed: float = 10.0

var movement_target: Vector2:
	set(value):
		movement_target = value
		print("%s has a movement target: %s" % [name, str(movement_target)])
		player_nav.target_position = movement_target
		print(player_nav.distance_to_target())

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
@onready var player_nav: NavigationAgent2D = %PlayerNav

func _ready() -> void:
	_connect_signals()
	player_sprite.texture = player_texture

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player_nav.target_position:
		var next_position = player_nav.get_next_path_position()
		#print(next_position)
		var movement_direction = global_position.direction_to(next_position)
		velocity = movement_direction * movement_speed
		move_and_slide()

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	connect("input_event", _on_input_event)

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
				print("Sorry; %s cannot be selected right now" % name)
