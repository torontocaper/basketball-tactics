class_name CourtFloorIsometric
extends TileMapLayer

signal cell_clicked(path_points: PackedVector2Array) ## Emitted when a cell is clicked on

var clicked_cell : Vector2
var clicked_cell_polygon_points : PackedVector2Array

var hovered_cell : Vector2
var hovered_cell_polygon_points : PackedVector2Array

var astar_start_cell := Vector2i.ZERO
var astar_end_cell : Vector2i

var astar_grid : AStarGrid2D
var astar_path_points : PackedVector2Array


@onready var clicked_polygon: Polygon2D = %ClickedPolygon
@onready var hovered_polyline: Line2D = %HoveredPolyline
@onready var astar_path_node: AstarPath = %AstarPath
@onready var hovered_coords_label: Label = %HoveredCoordsLabel
@onready var clicked_coords_label: Label = %ClickedCoordsLabel
@onready var start_cell_coords_label: Label = %StartCellCoords
@onready var target_cell_coords_label: Label = %TargetCellCoords


#func _ready() -> void: ## called when the Node enters the tree
	#astar_grid = _draw_astar_grid()


func _process(_delta: float) -> void: ## called every frame
	#hovered_cell = _update_hovered_cell(get_local_mouse_position())
	if astar_grid.is_in_boundsv(hovered_cell):
		astar_end_cell = hovered_cell
	astar_path_points = _get_astar_path(astar_start_cell, astar_end_cell)
	astar_path_node.draw_astar_path(astar_path_points)
	hovered_cell_polygon_points = _make_polygon(hovered_cell)
	hovered_polyline.draw_hovered_polyline(hovered_cell_polygon_points)
	_update_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		clicked_cell = local_to_map(get_local_mouse_position())
		if astar_grid.is_in_boundsv(clicked_cell):
			clicked_cell_polygon_points = _make_polygon(clicked_cell)
			clicked_polygon.draw_clicked_polygon(clicked_cell_polygon_points)
			cell_clicked.emit(astar_path_points)
			#_animate_journey(astar_start_cell, clicked_cell)
			astar_start_cell = clicked_cell


func _make_polygon(map_position : Vector2) -> PackedVector2Array:
	var polygon_points = PackedVector2Array([
			Vector2(map_to_local(map_position).x + 16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y + 8),
			Vector2(map_to_local(map_position).x -16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y - 8)
	])
	return polygon_points



#func _draw_astar_grid() -> AStarGrid2D:
	#var new_astar_grid = AStarGrid2D.new()
	#new_astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_RIGHT
	#var cell_size = tile_set.tile_size
	#new_astar_grid.cell_size = cell_size
	#new_astar_grid.region = get_used_rect()
	#new_astar_grid.update()
	#return new_astar_grid


func _get_astar_path(start : Vector2i, end : Vector2i) -> PackedVector2Array:
	var path = astar_grid.get_point_path(start, end)
	return path


func _update_hovered_cell(mouse_position : Vector2) -> Vector2i:
	var hovered_cell_coords = local_to_map(mouse_position)
	hovered_cell_polygon_points = _make_polygon(hovered_cell_coords)
	hovered_polyline.draw_hovered_polyline(hovered_cell_polygon_points)
	return hovered_cell_coords


func _update_ui() -> void:
	hovered_coords_label.text = "Hovered coords: %s" % hovered_cell
	clicked_coords_label.text = "Clicked coords: %s" % clicked_cell
	start_cell_coords_label.text = "Starting cell coords: %s" % astar_start_cell
	target_cell_coords_label.text = "Target cell coords: %s" % astar_end_cell
