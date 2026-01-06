#@tool
#@icon
class_name NavigationManager
extends Node
## Manages navigation

## Signals
signal path_found(path: Array[Dictionary])
## Enums
## Constants
## @export variables
## Regular variables
# -- Input --
var hovered_cell: Vector2: set = set_hovered_cell ## set from GameManager
var clicked_cell: Vector2: set = set_clicked_cell
# -- AStar --
var astar_start_cell: Vector2i ## The starting cell used for getting the AStar path
var astar_end_cell: Vector2i ## The end/target/destination cell used for getting the AStar path
var astar_path_points: PackedVector2Array ## The points along the AStar path
var astar_path_ids: Array[Vector2i] ## The cells along the AStar path
var astar_path_array: Array[Dictionary] ## Array of cells and IDs used for moving the player via signal
var astar_path_movement_cost: float ## Cost of a given movement for a given player
# -- Polygons --
var hovered_cell_polygon_points: PackedVector2Array ## The points in the polygon used to draw the 'hovered' graphic
var clicked_cell_polygon_points: PackedVector2Array ## Ditto the 'clicked' graphic


## @onready variables
# -- Child Nodes --
@onready var hovered_polyline: Line2D = %HoveredPolyline
@onready var astar_path: Line2D = %AstarPath
@onready var clicked_polygon: Polygon2D = %ClickedPolygon
# -- Other --
@onready var astar_grid: AStarGrid2D


func _ready() -> void:
	print_debug("Navigation Manager ready")


func set_hovered_cell(cell: Vector2i) -> void:
	if astar_grid.is_in_boundsv(cell):
		astar_end_cell = cell
		astar_path_points = _get_astar_path_points(astar_start_cell, astar_end_cell)
		astar_path_ids = _get_astar_path_ids(astar_start_cell, astar_end_cell)
		astar_path.points = astar_path_points
		hovered_cell_polygon_points = _make_polygon(cell)
		hovered_polyline.points = hovered_cell_polygon_points

func set_clicked_cell(cell: Vector2i) -> void:
	print_debug("Making a clicked polygon in cell %s" % cell)
	if astar_grid.is_in_boundsv(cell):
		clicked_cell_polygon_points = _make_polygon(cell)
		clicked_polygon.polygon = clicked_cell_polygon_points
		astar_path_array = _get_astar_path_array(astar_path_points, astar_path_ids)
		astar_path_movement_cost = _get_astar_path_movement_cost(astar_path_ids)
		path_found.emit(astar_path_array)
		astar_start_cell = cell

## Remaining virtual methods
func _get_astar_path_points(start: Vector2i, end: Vector2i) -> PackedVector2Array: ## get the points in the AStar path
	var point_path = astar_grid.get_point_path(start, end)
	return point_path


func _get_astar_path_ids(start: Vector2i, end: Vector2i) -> Array[Vector2i]: ## get the ids of the cells in the AStar path
	var id_path = astar_grid.get_id_path(start, end)
	return id_path

func _get_astar_path_array(points: PackedVector2Array, ids: Array[Vector2i]) -> Array[Dictionary]: ## make an array of Dictionaries for the AStar path
	var new_astar_path_array : Array[Dictionary]
	astar_path_array.clear()
	for x in points.size():
		new_astar_path_array.append(
			{
				"point": points[x],
				"id": ids[x]
			}
		)
	return new_astar_path_array

func _get_astar_path_movement_cost(ids: Array[Vector2i]) -> float: ## get the movement cost in points for the AStar path
	var movement_cost: float = 0.0
	var iterator = 0
	for id_index in ids.size() - 1:
		var step_direction: Vector2i = ids[iterator + 1] - ids[iterator]
		var step_cost: float = snapped(step_direction.length(), 0.5)
		movement_cost += step_cost
		iterator += 1
	return movement_cost


## Remaining methods
func draw_astar_grid(map_tile_size: Vector2, map_rect: Rect2i) -> void:
	# Called from the GameManager using info from the map/court
	print_debug("Drawing the AStar grid")
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar_grid.cell_size = map_tile_size
	astar_grid.region = map_rect
	astar_grid.update()

func _make_polygon(cell_id: Vector2) -> PackedVector2Array: ## Makes a polygon
	var polygon_points: PackedVector2Array
	polygon_points = PackedVector2Array([
			Vector2(
				astar_grid.get_point_position(cell_id).x + (astar_grid.cell_size.x / 2), 
				astar_grid.get_point_position(cell_id).y),
			Vector2(
				astar_grid.get_point_position(cell_id).x, 
				astar_grid.get_point_position(cell_id).y + (astar_grid.cell_size.y / 2)),
			Vector2(
				astar_grid.get_point_position(cell_id).x -(astar_grid.cell_size.x / 2), 
				astar_grid.get_point_position(cell_id).y),
			Vector2(
				astar_grid.get_point_position(cell_id).x, 
				astar_grid.get_point_position(cell_id).y - (astar_grid.cell_size.y / 2))
			])
	return polygon_points
