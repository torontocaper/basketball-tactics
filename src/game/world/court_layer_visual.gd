#@tool
#@icon(icon_path: String)
class_name CourtLayerVisual
extends CourtLayer
## The visual court layer, responsible for displaying movement distances and paths

#region Constants
const CLICK_INDICATOR = preload("uid://bnm71kxddqynl") ## [PackedScene] representing [member click_indicator]
const MAIN_THEME = preload("uid://c0lrucuyge77v") ## [Theme] resource for displaying move costs
const PATH_INDICATOR = preload("uid://dkswoobiwgwxy") ## [PackedScene] representing [member path_indicator]
#endregion

#region Properties
var active_player_move_range : int ## The movement range for the currently active player
var click_indicator : CPUParticles2D ## [CPUParticles2D] that indicates a click
var court_cell_graphics : Dictionary[Vector2i, Dictionary] ## Dictionary representing the graphics for each cell; created by the _create_cell_graphics method
var current_dijkstra_map : Dictionary[Vector2i, Dictionary] ## Dictionary representing the current map provided by [MoveManager]
var path_indicator : Line2D ## [Line2D] that shows a potential movement path
#endregion

#region Methods
	#region Overrides
func _ready() -> void:
	super() # Run the CourtLayer _ready function, which creates the court_cells variable
	court_cell_graphics = _create_cell_graphics(court_cells)
	click_indicator = CLICK_INDICATOR.instantiate()
	add_child(click_indicator)
	path_indicator = PATH_INDICATOR.instantiate()
	add_child(path_indicator)
	MoveManager.connect("map_updated", update_distances)
	MoveManager.connect("path_found", display_new_path)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		event = event as InputEventMouseButton
		indicate_click(local_to_map(event.position))
	#endregion

	#region Core
## Display the path to the selected target cell. Called when [MoveManager] finds a path
func display_new_path(new_path : Array, new_path_cost : int) -> void:
	if new_path:
		active_player_move_range = TurnManager.active_player.available_energy
		if new_path_cost > active_player_move_range:
			return
		else:
			path_indicator.clear_points()
			for point_coords in new_path:
				var point_distance : int = current_dijkstra_map[point_coords].distance_from_source
				if point_distance <= active_player_move_range:
					path_indicator.add_point(map_to_local(point_coords))

## Indicate a click has occurred at a given cell
func indicate_click(cell_to_indicate : Vector2i) -> void:
	click_indicator.position = map_to_local(cell_to_indicate)
	click_indicator.restart()

## Snap a given [Player] to the closest cell on the map
func snap_player_to_grid(player_to_snap : Player) -> void:
	player_to_snap.position = map_to_local(player_to_snap.starting_coords)

## Update distances displayed on (reachable) cells. Called when [MoveManager] updates the map from a new source cell
func update_distances(dijkstra_map : Dictionary[Vector2i, Dictionary]) -> void:
	path_indicator.clear_points()
	current_dijkstra_map = dijkstra_map
	if current_dijkstra_map.size() == 0: # If there is no Dijkstra map to draw (ie: no valid source cell), hide all graphics
		_hide_cell_graphics(court_cell_graphics)
	else:
		active_player_move_range = TurnManager.active_player.available_energy
		for point in court_cells:
			var point_distance : int = current_dijkstra_map[point].distance_from_source
			var cell_label : Label = court_cell_graphics.get(point).label
			if point_distance == 0 or point_distance > active_player_move_range:
				cell_label.text = ""
			else:
				cell_label.text = str(point_distance)
			if TurnManager.active_team.name == "GreenTeam":
				cell_label.rotation_degrees = 180
			else:
				cell_label.rotation_degrees = 0
	#endregion

	#region Private/Helper
## Initialize the Dictionary representing the graphics for each cell
## Creates a Dictionary entry for each cell in 
func _create_cell_graphics(cells : Array[Vector2i]) -> Dictionary[Vector2i, Dictionary]:
	var graphics : Dictionary[Vector2i, Dictionary] = {}
	for cell in cells:
		graphics[cell] = {}
		var cell_label : Label = Label.new()
		cell_label.name = "label_%s_%s" % [str(cell.x), str(cell.y)]
		cell_label.theme = MAIN_THEME
		cell_label.position = map_to_local(cell)
		cell_label.offset_transform_enabled = true
		cell_label.offset_transform_position_ratio = Vector2(-0.5, -0.5)
		cell_label.z_index = 100
		add_child(cell_label)
		graphics[cell].label = cell_label
	return graphics

## Hide the cell_graphics Dictionary
func _hide_cell_graphics(graphics : Dictionary[Vector2i, Dictionary]) -> void:
	for graphic in graphics:
		var cell_label : Label = graphics.get(graphic).label
		cell_label.text = ""
	#endregion
#endregion
