class_name ClickedPolygon
extends Polygon2D

@export var movement_speed := 10.0

#func animate_journey(path : PackedVector2Array) -> void:
	#for step in path:
		#draw_clicked_polygon()
		
func draw_clicked_polygon(polygon_points : PackedVector2Array) -> void:
	polygon = polygon_points
	# queue_redraw()
