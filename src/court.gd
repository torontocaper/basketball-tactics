#@tool
#@icon(icon_path: String)
class_name Court
extends StaticBody3D
## The court! The surface the game is played on

#signal
#enum
#const
#@export var
#var
@onready var movement_target: MeshInstance3D = %MovementTarget

# OVERRIDES

func _ready() -> void:
	_connect_signals()


# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	input_event.connect(_on_input_event)

# RECEIVERS


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print_debug(event_position)
		movement_target.position = event_position
