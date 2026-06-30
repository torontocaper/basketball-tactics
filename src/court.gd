#@tool
@icon("uid://dg3f18xvus5g0")
class_name Court
extends Area2D
## The surface a [Match] is played on.

signal court_clicked
#enum
#const
#@export var
#var
#@onready var

# OVERRIDES

func _ready() -> void:
	_connect_signals()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS
func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx: int):
	if event.is_pressed() and event is InputEventMouseButton:
		print("Court clicked")
		var click_position: Vector2 = get_global_mouse_position()
		court_clicked.emit(click_position)
