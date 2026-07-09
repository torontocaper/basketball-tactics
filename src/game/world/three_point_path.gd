@tool
#@icon(icon_path: String)
#class_name _3PointPath
extends Path2D
## Documentation comments

#signal
#enum
#const
#@export var
var curve_points : PackedVector2Array
#var
#@onready var
@onready var two_point_polygon: Polygon2D = $TwoPointPolygon

# OVERRIDES

func _ready() -> void:
	print_debug("_3PointPath ready")
	curve_points = curve.get_baked_points()
	print_debug("Curve has %s points" % curve_points.size())
	two_point_polygon.polygon = curve_points

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals() -> void:
	pass

# RECEIVERS
