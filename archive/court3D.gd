#@tool
#@icon(icon_path: String)
class_name Court3D
extends StaticBody3D
## The surface the game is played on

signal movement_target_moved
signal movement_target_set

@onready var movement_target: Decal = %MovementTarget
@onready var target_label: Label3D = %TargetLabel

# OVERRIDES

func _ready() -> void:
	_connect_signals()

func _process(_delta: float) -> void:
	target_label.text = str(target_label.global_position)

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS
func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseMotion:
		var movement_target_target = event_position
		var movement_tween = movement_target.create_tween()
		movement_tween.tween_property(movement_target, "position", movement_target_target, 0.1)
		movement_target_moved.emit(movement_target.position)
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		movement_target_set.emit(event_position)
