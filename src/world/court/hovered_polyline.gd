class_name HoveredPolyline
extends Line2D

func _ready() -> void:
	width = 1.0

func draw_hovered_polyline(hovered_polygon_points : PackedVector2Array) -> void:
	points = hovered_polygon_points
