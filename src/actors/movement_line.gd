#@tool
#@icon(icon_path: String)
class_name MovementLine
extends MeshInstance3D
## Documentation comments

#signal
#enum
#const
#@export var
var path_mesh : ImmediateMesh
#@onready var

# OVERRIDES

func _ready() -> void:
	path_mesh = mesh as ImmediateMesh
	_connect_signals()

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE
func build_path_mesh(path_points: PackedVector3Array) -> void:
	path_mesh.clear_surfaces()
	path_mesh.surface_begin(Mesh.PRIMITIVE_POINTS)
	for point in path_points:
		path_mesh.surface_add_vertex(point)
	path_mesh.surface_end()

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
