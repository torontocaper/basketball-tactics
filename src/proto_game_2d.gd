#@tool
#@icon
#class_name
extends Node2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
# Navigation
#var astar_grid: AStarGrid2D ## The AStar grid used for navigation
#var astar_cell_size: Vector2
#var astar_path_array: Array[Dictionary]
#var astar_path_points: PackedVector2Array ## The points along the AStar path
#var astar_path_ids: Array[Vector2i] ## The cells along the AStar path
#var astar_path_movement_cost: float ## The cost in movement points for moving along a path
#var astar_start_cell:= Vector2i.ZERO ## The starting cell used for getting the AStar path
#var astar_end_cell: Vector2i ## The end/target/destination cell used for getting the AStar path
# Input
#var clicked_cell: Vector2 ## The cell clicked by the player
#var hovered_cell: Vector2 ## The cell hovered over by the player
#var hovered_cell_polygon_points: PackedVector2Array ## The points in the polygon used to draw the 'hovered' graphic

## @onready variables
# Child Nodes
@onready var proto_player_2d: ProtoPlayer2D = %ProtoPlayer2d
@onready var court_floor_isometric: TileMapLayer = %CourtFloorIsometric
#@onready var astar_path: Line2D = %AstarPath
#@onready var clicked_polygon: Polygon2D = %ClickedPolygon
#@onready var hovered_polyline: Line2D = %HoveredPolyline
@onready var debug_ui: DebugUI = %DebugUI
@onready var navigation_manager: NavigationManager = %NavigationManager


func _ready() -> void:
	print_debug("Game Manager ready")
	# Get the tile size and used rect from the TilemapLayer and send the info to NavigationManager
	var map_tile_size:= court_floor_isometric.tile_set.tile_size
	var map_rect:= court_floor_isometric.get_used_rect()
	navigation_manager.draw_astar_grid(map_tile_size, map_rect)
	# Move the player to cell with ID (0, 0)
	proto_player_2d.position = court_floor_isometric.map_to_local(Vector2i.ZERO)
	# Connect signals
	navigation_manager.connect("path_found", proto_player_2d.move_along_path)


#func _process(_delta: float) -> void:
	#if astar_grid.is_in_boundsv(hovered_cell):
		#astar_end_cell = hovered_cell
	#astar_path_points = _get_astar_path_points(astar_start_cell, astar_end_cell)
	#astar_path_ids = _get_astar_path_ids(astar_start_cell, astar_end_cell)
	#astar_path.set("points", astar_path_points)
	#hovered_cell_polygon_points = _make_polygon(hovered_cell)
	#hovered_polyline.set("points", hovered_cell_polygon_points)
	##debug_ui.update_ui([get_local_mouse_position(), clicked_cell, astar_start_cell, astar_end_cell, astar_path_points, astar_path_ids])


func _unhandled_input(event: InputEvent) -> void:
	# Get the mouse position and, using the TileMapLayer for convenience, set the hovered_cell navigation variable
	if navigation_manager.astar_grid:
		navigation_manager.hovered_cell = court_floor_isometric.local_to_map(get_local_mouse_position())

	
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
			# Get the mouse position and, using the TileMapLayer for convenience, set the hovered_cell navigation variable
			navigation_manager.clicked_cell = court_floor_isometric.local_to_map(get_local_mouse_position())
		#if astar_grid.is_in_boundsv(clicked_cell):
			#var clicked_cell_polygon_points = _make_polygon(clicked_cell)
			#clicked_polygon.set("polygon", clicked_cell_polygon_points)
			#astar_path_array = _get_astar_path_array(astar_path_points, astar_path_ids)
		#proto_player_2d.move_along_path(astar_path_array)
			#astar_path_movement_cost = _get_astar_path_movement_cost(astar_path_ids)
			#print_debug("This move costs %s points" % astar_path_movement_cost)
			#astar_start_cell = clicked_cell

#
#func _draw_astar_grid() -> AStarGrid2D:
	#var new_astar_grid = AStarGrid2D.new()
	#new_astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	#new_astar_grid.cell_size = astar_cell_size
	#new_astar_grid.region = court_floor_isometric.get_used_rect()
	#new_astar_grid.update()
	#return new_astar_grid
#
#
#func _get_astar_path_movement_cost(ids: Array[Vector2i]) -> float:
	#var movement_cost: float = 0.0
	#var iterator = 0
	#for id_index in ids.size() - 1:
		#var step_direction: Vector2i = ids[iterator + 1] - ids[iterator]
		#var step_cost: float = snapped(step_direction.length(), 0.5)
		#movement_cost += step_cost
		#iterator += 1
	#return movement_cost
#
#
#func _get_astar_path_array(points: PackedVector2Array, ids: Array[Vector2i]) -> Array[Dictionary]:
	#var new_astar_path_array : Array[Dictionary]
	#astar_path_array.clear()
	#for x in points.size():
		#new_astar_path_array.append(
			#{
				#"point": points[x],
				#"id": ids[x]
			#}
		#)
	#return new_astar_path_array
#
#
#func _get_astar_path_points(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	#var point_path = astar_grid.get_point_path(start, end)
	#return point_path
#
#
#func _get_astar_path_ids(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	#var id_path = astar_grid.get_id_path(start, end)
	#return id_path
#
#
#func _make_polygon(map_position: Vector2) -> PackedVector2Array:
	#var polygon_points = PackedVector2Array([
			#Vector2(court_floor_isometric.map_to_local(map_position).x + (astar_cell_size.x / 2), court_floor_isometric.map_to_local(map_position).y),
			#Vector2(court_floor_isometric.map_to_local(map_position).x, court_floor_isometric.map_to_local(map_position).y + (astar_cell_size.y / 2)),
			#Vector2(court_floor_isometric.map_to_local(map_position).x -(astar_cell_size.x / 2), court_floor_isometric.map_to_local(map_position).y),
			#Vector2(court_floor_isometric.map_to_local(map_position).x, court_floor_isometric.map_to_local(map_position).y - (astar_cell_size.y / 2))
	#])
	#return polygon_points
