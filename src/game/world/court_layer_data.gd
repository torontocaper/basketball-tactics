#@tool
#@icon(icon_path: String)
class_name CourtLayerData
extends CourtLayer
## The layer of the court responsible for data -- point values, player positions, etc. 

#region Signals
## Emitted when a source cell for navigation is set
signal source_cell_set(source_cell_coords : Vector2i, occupied_cells : Dictionary[Player, Vector2i])

## Emitted when a target cell for navigation is set.
signal target_cell_set(target_cell_coords : Vector2i)
#region

#region Enums
## Integers representing movement costs for orthogonal (N/W/S/E) and diagonal (NW/SW/SE/NE) neighbor cells
enum MovementCost {
	MOVEMENT_COST_ORTHOGONAL = 2, ## The cost for moving orthogonally (N/W/S/E)
	MOVEMENT_COST_DIAGONAL = 3 ## The cost for moving diagonally (NW/SW/SE/NE)
	}
#region

#region Properties
## Set of cells that are currently occupied by [Player]s. 
var occupied_cells : Dictionary[Player, Vector2i]

## Source cell for navigation calculation. Usually the same as the active [Player]'s current coordinates
var source_cell : Vector2i:
	set(value):
		source_cell = value
		source_cell_set.emit(source_cell, occupied_cells)

## Target cell for navigation calculation. Set by clicking on an unoccupied cell within the active [Player]'s movement range
var target_cell : Vector2i:
	set(value):
		target_cell = value
		target_cell_set.emit(target_cell)
#region

#region Methods
	#region Overrides
func _ready() -> void:
	# Run the CourtLayer _ready function, which creates the court_cells variable
	super()
	# Disable input by default
	set_process_input(false) 
	# When a new player is activated, set their location as the source_cell for navigation
	TurnManager.active_player_set.connect(set_player_as_source) 
	# When source_cell is set, get MoveManager to update the Dijkstra map
	source_cell_set.connect(MoveManager.update_map) 
	# When target_cell is set, get the path to that cell from MoveManager
	target_cell_set.connect(MoveManager.get_move_path) 
	# Create the initial Dijkstra graph and send it to MoveManager
	MoveManager.dijkstra_graph = _create_dijkstra_graph(court_cells) 

## Process [InputEvent]s on this Node. Used for detecting where the user wants to move a given [Player]
## NOTE: This only runs when [member source_cell] has been selected
func _input(event: InputEvent) -> void: 
	if event is InputEventMouseButton and event.is_pressed():
		# Get the click position in map space
		var clicked_cell = local_to_map(event.position) 
		# If the clicked cell is a) in-bounds and b) not already the source_cell ...
		if clicked_cell in court_cells and clicked_cell != source_cell:
			# If the clicked_cell is already the target_cell ...
			if clicked_cell == target_cell: 
				# ... this is a double-click, which confirms the move.
				initiate_move() 
			else:
				# ... otherwise, make the clicked_cell the new target_cell.
				target_cell = clicked_cell 
	#endregion

## Start moving the [Player]. Called from [method _input] when [member target_cell] is re-clicked, confirming the move
func initiate_move() -> void:
	# Get the array of coords for the current path from MoveManager
	var move_path_cells : Array = MoveManager.path_coords 
	# Get the cost for the given move from MoveManager
	var move_path_cost : int = MoveManager.path_cost 
	# Get the active Player from TurnManager
	var active_player : Player = TurnManager.active_player 
	# Initialize Array that will eventually hold global coords for each cell in the move path
	var move_path_global : Array[Vector2] 
	# Get the global coordinates for each cell in the path, and add them to the Array
	for cell in move_path_cells:
		var move_point_global : Vector2 = to_global(map_to_local(cell))
		move_path_global.append(move_point_global)
	# If the currently active Player has enough energy...
	if active_player.available_energy >= move_path_cost: 
		# ... move them to the target. Wait for the move to finish ...
		await active_player.move_along_path(move_path_global, move_path_cost) 
		# ... then update the Player's coords property ... 
		active_player.coords = local_to_map(to_local(active_player.global_position)) 
		# ... and their cell in the occupied_cells Dictionary ...
		occupied_cells[active_player] = active_player.coords
		# ... finally, update the source_cell for movement calculations
		source_cell = active_player.coords 

## Set the navigation source cell based on a [Player]'s location. Called from [TurnManager] when a new [member TurnManager.active_player] is set
func set_player_as_source(source_player : Player) -> void:
	# If a valid Player is selected ... 
	if source_player:
		# ... set the navigation source_cell to their location in map space ...
		source_cell = local_to_map(to_local(source_player.global_position))
		# ... and allow input
		set_process_input(true)
	# Otherwise, it's likely that the Player has been deselected ...
	else: 
		# ... so reset the source_cell to the default ...
		source_cell = Vector2i(-1, -1)
		# ... and disable input until another Player is selected
		set_process_input(false)

	#region Helpers
## Create the Dijkstra graph for [MoveManager]
func _create_dijkstra_graph(cells : Array[Vector2i]) -> Dictionary[Vector2i, Dictionary]:
	var new_graph : Dictionary[Vector2i, Dictionary]
	for cell in cells:
		var cell_neighbors : Dictionary[Vector2i, int] = _get_cell_neighbors(cell)
		new_graph[cell] = cell_neighbors
	return new_graph

## For a given cell ([param cell_coords]) in the Dijkstra graph, find its immediate neighbors and assign travel distances to each. 
func _get_cell_neighbors(cell_coords: Vector2i) -> Dictionary[Vector2i, int]:
	var new_neighbors : Dictionary[Vector2i, int] = {}
	var orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(cell_coords) 
	var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(cell_coords)
	for o in orthogonal_neighbors:
		if o in court_cells:
			new_neighbors[o] = MovementCost.MOVEMENT_COST_ORTHOGONAL
	for d in diagonal_neighbors:
		if d in court_cells:
			new_neighbors[d] = MovementCost.MOVEMENT_COST_DIAGONAL
	return new_neighbors
	
## Get the coordinates for the diagonal neighbors of the cell at [param cell_coords].
func _get_diagonal_neighbors(cell_coords: Vector2i) -> Array[Vector2i]: 
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors
	#endregion
#endregion
