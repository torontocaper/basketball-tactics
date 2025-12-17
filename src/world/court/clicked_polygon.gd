class_name ClickedPolygon
extends Polygon2D

@export var movement_speed := 10.0


func draw_clicked_polygon(polygon_points : PackedVector2Array) -> void:
	polygon = polygon_points
