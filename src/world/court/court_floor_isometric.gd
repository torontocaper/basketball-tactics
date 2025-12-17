class_name CourtFloorIsometric
extends TileMapLayer


#var clicked_cell : Vector2
#var clicked_cell_polygon_points : PackedVector2Array
#
#var hovered_cell : Vector2
#var hovered_cell_polygon_points : PackedVector2Array
#
#var astar_start_cell := Vector2i.ZERO
#var astar_end_cell : Vector2i
#
#var astar_grid : AStarGrid2D
#var astar_path_points : PackedVector2Array
#
#
#@onready var clicked_polygon: Polygon2D = %ClickedPolygon
#@onready var hovered_polyline: Line2D = %HoveredPolyline
#@onready var astar_path_node: AstarPath = %AstarPath
##@onready var hovered_coords_label: Label = %HoveredCoordsLabel
##@onready var clicked_coords_label: Label = %ClickedCoordsLabel
##@onready var start_cell_coords_label: Label = %StartCellCoords
##@onready var target_cell_coords_label: Label = %TargetCellCoords


func make_polygon(map_position : Vector2) -> PackedVector2Array:
	var polygon_points = PackedVector2Array([
			Vector2(map_to_local(map_position).x + 16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y + 8),
			Vector2(map_to_local(map_position).x -16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y - 8)
	])
	return polygon_points
