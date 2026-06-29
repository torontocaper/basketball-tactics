#@tool
@icon("uid://2dqc4hvtik6l")
class_name Player
extends CharacterBody2D
## Class representing a player on the court (not the person playing the game).

signal player_selected
#enum
#const
@export var player_texture: Texture2D
#var
@onready var player_sprite: Sprite2D = %PlayerSprite

# OVERRIDES

func _ready() -> void:
	_connect_signals()
	player_sprite.texture = player_texture

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	connect("input_event", _on_input_event)

# RECEIVERS
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		player_selected.emit()
		print_debug("%s selected" % name)
