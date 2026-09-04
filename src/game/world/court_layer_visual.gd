#@tool
#@icon(icon_path: String)
class_name CourtLayerVisual
extends CourtLayer
## The visual court layer, responsible for displaying movement distances and paths

#region Constants
## [PackedScene] representing [member click_indicator]
const CLICK_INDICATOR = preload("uid://bnm71kxddqynl")

## [Theme] resource for displaying move costs
const MAIN_THEME = preload("uid://c0lrucuyge77v") 

## [PackedScene] representing [member path_indicator]
const PATH_INDICATOR = preload("uid://dkswoobiwgwxy") 
#endregion

#region Properties
## The movement range for the currently active [Player]
var active_player_move_range : int 

## [CPUParticles2D] that indicates a click
var click_indicator : CPUParticles2D 

## [Dictionary] representing the graphics for each cell; created by [method _create_cell_graphics]
var court_cell_graphics : Dictionary[Vector2i, Dictionary] 

## [Dictionary] representing the current map provided by [MoveManager]
var current_dijkstra_map : Dictionary[Vector2i, Dictionary] 

## [Line2D] that shows a potential movement path
var path_indicator : Line2D 
#endregion

#region Methods
	#region Overrides
func _ready() -> void:
	# Run the CourtLayer _ready function, which creates the court_cells variable
	super() 
	# Fill in the court_cell_graphics Dictionary 
	court_cell_graphics = _create_cell_graphics(court_cells)
	# Add the click_ and path_ indicators to the scene
	click_indicator = CLICK_INDICATOR.instantiate()
	add_child(click_indicator)
	path_indicator = PATH_INDICATOR.instantiate()
	add_child(path_indicator)
	# Connect signals:
	# Update the displayed move distances when the map is updated, and;
	MoveManager.map_updated.connect(update_distances)
	# Display a new move path when a new path is found
	MoveManager.path_found.connect(display_new_path)
	# Hide graphics when a turn ends
	TurnManager.turn_ended.connect(_hide_cell_graphics)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		event = event as InputEventMouseButton
		indicate_click(local_to_map(event.position))
	#endregion

	#region Core
## Display the path to the selected target cell. Called when [MoveManager] finds a path.
## [br][br]
## [param new_path] is an [Array] of points in map space, which need to be converted to local space for display
func display_new_path(new_path : Array, new_path_cost : int) -> void:
	if new_path:
		active_player_move_range = TurnManager.active_player.available_energy
		# If the move is out of range ...
		if new_path_cost > active_player_move_range:
			# ... do nothing; otherwise ...
			return
		else:
			# ... clear out the current path line ...
			path_indicator.clear_points()
			for point_coords in new_path:
				# ... get the distance to each point in the path ... 
				var point_distance : int = current_dijkstra_map[point_coords].distance_from_source
				# ... and if it's within range, add that point to the path line.
				if point_distance <= active_player_move_range:
					path_indicator.add_point(map_to_local(point_coords))

## Indicate a click has occurred at a given cell
## [br][br]
## [param cell_to_indicate] should be in map space
func indicate_click(cell_to_indicate : Vector2i) -> void:
	click_indicator.position = map_to_local(cell_to_indicate)
	click_indicator.restart()

## Snap a given [Player] to the closest cell on the map.
## [br][br]
## Called from [Court] after players are added to [member Court.players_on_court]
func snap_player_to_grid(player_to_snap : Player) -> void:
	player_to_snap.position = map_to_local(player_to_snap.starting_coords)

## Update distances displayed on (reachable) cells. Called when [MoveManager] updates the map from a new source_cell
func update_distances(dijkstra_map : Dictionary[Vector2i, Dictionary]) -> void:
	# Reset the path_indicator
	path_indicator.clear_points()
	# Assign the new dijkstra_map to the current_dijkstra_map variable
	current_dijkstra_map = dijkstra_map
	# If there is no Dijkstra map to draw (ie: no valid source cell) ...
	if current_dijkstra_map.size() == 0: 
		# ... hide all graphics
		_hide_cell_graphics()
	else:
		# Get the move range for the active Player ...
		active_player_move_range = TurnManager.active_player.available_energy
		for point in court_cells:
			var point_distance : int = current_dijkstra_map[point].distance_from_source
			var cell_label : Label = court_cell_graphics.get(point).label
			# If a given point is unreachable ...
			if point_distance == 0 or point_distance > active_player_move_range:
				# ... clear out the text on its label
				cell_label.text = ""
			else:
				# ... otherwise, display its distance from the active Player
				cell_label.text = str(point_distance)
			# If the Green team is active ...
			if TurnManager.active_team.name == "GreenTeam":
				# ... rotate all labels by 180 degrees
				cell_label.rotation_degrees = 180
			else:
				cell_label.rotation_degrees = 0
	#endregion

	#region Private/Helper
## Initialize the [Dictionary] representing the graphics for each cell
#NOTE: Is it worth creating an inner class for CellGraphics?
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
func _hide_cell_graphics() -> void:
	for graphic in court_cell_graphics:
		var cell_label : Label = court_cell_graphics.get(graphic).label
		cell_label.text = ""
	#endregion
#endregion
