#@tool
#@icon(icon_path: String)
class_name MainCamera
extends Camera3D
## Documentation comments

#signal
#enum
#const
#@export var
#var
#@onready var
@onready var camera_ray: RayCast3D = %CameraRay

# OVERRIDES

func _ready() -> void:
	_connect_signals()

func _process(_delta: float) -> void:
	if camera_ray.is_colliding():
		print("Camera ray colliding at %s" % camera_ray.get_collision_point())

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
