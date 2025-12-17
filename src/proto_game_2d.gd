#@tool
#@icon
#class_name
extends Node2D
## Documentation comments

## Signals
signal cell_clicked(path_points: PackedVector2Array) ## Emitted when a cell is clicked on

## Enums
## Constants
## @export variables
## Regular variables
# Navigation
var astar_grid: AStarGrid2D ## The AStar grid used for navigation
var astar_path_points: PackedVector2Array ## The points along the AStar path
var astar_path_ids: Array[Vector2i] ## The cells along the AStar path
var astar_start_cell:= Vector2i.ZERO ## The starting cell used for getting the AStar path
var astar_end_cell: Vector2i ## The end/target/destination cell used for getting the AStar path
# Input
var clicked_cell: Vector2 ## The cell clicked by the player
var hovered_cell: Vector2 ## The cell hovered over by the player
var hovered_cell_polygon_points: PackedVector2Array ## The points in the polygon used to draw the 'hovered' graphic

## @onready variables
# Child Nodes
@onready var proto_player_2d: AnimatedSprite2D = %ProtoPlayer2d
@onready var court_floor_isometric: CourtFloorIsometric = %CourtFloorIsometric
@onready var astar_path: AstarPath = %AstarPath
@onready var clicked_polygon: ClickedPolygon = %ClickedPolygon
@onready var hovered_polyline: HoveredPolyline = %HoveredPolyline
@onready var debug_ui: CanvasLayer = %DebugUI

## Overridden built-in virtual methods
func _ready() -> void:
	astar_grid = _draw_astar_grid()
	cell_clicked.connect(proto_player_2d.move_along_path)


func _process(_delta: float) -> void:
	hovered_cell = court_floor_isometric.local_to_map(get_local_mouse_position())
	if astar_grid.is_in_boundsv(hovered_cell):
		astar_end_cell = hovered_cell
	astar_path_points = _get_astar_path_points(astar_start_cell, astar_end_cell)
	astar_path_ids = _get_astar_path_ids(astar_start_cell, astar_end_cell)
	astar_path.draw_astar_path(astar_path_points)
	## TODO: improve this section
	hovered_cell_polygon_points = court_floor_isometric.make_polygon(hovered_cell)
	hovered_polyline.draw_hovered_polyline(hovered_cell_polygon_points)
	debug_ui.update_ui([hovered_cell, clicked_cell, astar_start_cell, astar_end_cell, astar_path_points, astar_path_ids])


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		clicked_cell = court_floor_isometric.local_to_map(get_local_mouse_position())
		if astar_grid.is_in_boundsv(clicked_cell):
			var clicked_cell_polygon_points = court_floor_isometric.make_polygon(clicked_cell)
			clicked_polygon.draw_clicked_polygon(clicked_cell_polygon_points)
			cell_clicked.emit(astar_path_points)
			astar_start_cell = clicked_cell

## Remaining virtual methods
func _draw_astar_grid() -> AStarGrid2D:
	var new_astar_grid = AStarGrid2D.new()
	new_astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_RIGHT
	var cell_size = court_floor_isometric.tile_set.tile_size
	new_astar_grid.cell_size = cell_size
	new_astar_grid.region = court_floor_isometric.get_used_rect()
	new_astar_grid.update()
	return new_astar_grid


func _get_astar_path_points(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	var point_path = astar_grid.get_point_path(start, end)
	return point_path


func _get_astar_path_ids(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	var id_path = astar_grid.get_id_path(start, end)
	return id_path

## Overridden custom methods
## Remaining methods
## Subclasses
