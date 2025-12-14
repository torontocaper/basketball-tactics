extends TileMapLayer

var click_position_map : Vector2
var click_polygon_points : PackedVector2Array
var hover_position_map : Vector2
var hover_polygon_points : PackedVector2Array
var starting_cell := Vector2i.ZERO
var target_cell : Vector2i
var astar_grid : AStarGrid2D
var astar_path_points : PackedVector2Array

@onready var clicked_polygon: Polygon2D = $ClickedPolygon
@onready var hovered_polyline: Line2D = $HoveredPolyline
@onready var astar_path: AstarPath = $AstarPath
@onready var hovered_coords_label: Label = %HoveredCoordsLabel
@onready var clicked_coords_label: Label = %ClickedCoordsLabel
@onready var start_cell_coords: Label = %StartCellCoords
@onready var target_cell_coords: Label = %TargetCellCoords

func _ready() -> void:
	astar_grid = _draw_astar_grid()
	start_cell_coords.text = "Starting cell coords: %s" % starting_cell

func _process(_delta: float) -> void:
	hover_position_map = local_to_map(get_local_mouse_position())
	hovered_coords_label.text = "Hovered coords: %s" % hover_position_map
	hover_polygon_points = _make_polygon(hover_position_map)
	hovered_polyline.draw_hovered_polyline(hover_polygon_points)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		click_position_map = local_to_map(get_local_mouse_position())
		clicked_coords_label.text = "Clicked coords: %s" % click_position_map
		print_debug("You clicked a tile at point " + str(click_position_map))
		click_polygon_points = _make_polygon(click_position_map)
		clicked_polygon.draw_clicked_polygon(click_polygon_points)
		target_cell = click_position_map
		target_cell_coords.text = "Target cell coords: %s" % target_cell
		astar_path_points = _get_astar_path(starting_cell, target_cell)
		print_debug("Got a path with %s points" % astar_path_points.size())
		astar_path.draw_astar_path(astar_path_points)
		starting_cell = target_cell
		start_cell_coords.text = "Starting cell coords: %s" % starting_cell


func _make_polygon(map_position : Vector2) -> PackedVector2Array:
	var polygon_points = PackedVector2Array([
			Vector2(map_to_local(map_position).x + 16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y + 8),
			Vector2(map_to_local(map_position).x -16, map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y - 8)
	])
	return polygon_points

func _draw_astar_grid() -> AStarGrid2D:
	var new_astar_grid = AStarGrid2D.new()
	new_astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_RIGHT
	var cell_size = tile_set.tile_size
	new_astar_grid.cell_size = cell_size
	#new_astar_grid.offset = Vector2(cell_size.x / 2.0, cell_size.y / 2.0)
	new_astar_grid.region = get_used_rect()
	new_astar_grid.update()
	return new_astar_grid


func _get_astar_path(start : Vector2i, end : Vector2i) -> PackedVector2Array:
	var path = astar_grid.get_point_path(start, end)
	return path
