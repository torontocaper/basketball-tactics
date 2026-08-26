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
	MOVEMENT_COST_ORTHOGONAL = 2,
	MOVEMENT_COST_DIAGONAL = 3
	}
#region

#region Properties
## Set of cells that are currently occupied by Players. 
var occupied_cells : Dictionary[Player, Vector2i]
## Source cell for navigation calculation. Usually the same as the active [Player]'s current coordinates
var source_cell : Vector2i:
	set(value):
		source_cell = value
		source_cell_set.emit(source_cell, occupied_cells)
## Target cell for navigation calculation. Set by clicking on an unoccupied cell that's within the active [Player]'s movement range
var target_cell : Vector2i:
	set(value):
		target_cell = value
		target_cell_set.emit(target_cell)
#region

#region Methods
func _ready() -> void:
	super() # Run the CourtLayer _ready function, which creates the cells_in_play variable
	set_process_input(false)
	TurnManager.connect("active_player_set", set_source_cell)
	connect("source_cell_set", MoveManager.update_map)
	connect("target_cell_set", MoveManager.get_move_path)
	MoveManager.dijkstra_graph = _create_dijkstra_graph(court_cells)

func _input(event: InputEvent) -> void: ## Only runs when a player/source cell has already been selected
	if event is InputEventMouseButton and event.is_pressed():
		var clicked_cell = local_to_map(event.position)
		if clicked_cell in court_cells:
			if target_cell == clicked_cell:
				initiate_move()
			else:
				target_cell = clicked_cell

## Start moving the player. Called from _input when the target_cell is re-clicked, confirming the move
func initiate_move() -> void:
	var move_path_cells : Array = MoveManager.path_coords # Get the array of coords for the current path from MoveManager
	var move_path_cost : int = MoveManager.path_cost # Get the cost for the given move from MoveManager
	var active_player : Player = TurnManager.active_player # Get the active Player from TurnManager
	var move_path_global : Array[Vector2] # Array that will eventually hold global coords for each cell in the move path
	for cell in move_path_cells:
		var move_point_global : Vector2 = to_global(map_to_local(cell))
		move_path_global.append(move_point_global)
	if active_player.available_energy >= move_path_cost: # If the currently active Player has enough energy...
		await active_player.move_along_path(move_path_global, move_path_cost) # Move them to the target. Wait for the move to finish
		active_player.coords = local_to_map(to_local(active_player.global_position)) # Update the Player's coords
		occupied_cells[active_player] = active_player.coords # Update this player's cell in the occupied_cells Dictionary
		source_cell_set.emit(active_player.coords, occupied_cells) # Update the source_cell for movement calculations

## Called from TurnManager when a player is selected
func set_source_cell(source_player : Player) -> void:
	if source_player:
		set_process_input(true)
		source_cell = local_to_map(to_local(source_player.global_position))
	else:
		set_process_input(false)
		source_cell = Vector2i(-1, -1)

## Create the Dijkstra graph for [MoveManager]
func _create_dijkstra_graph(cells : Array[Vector2i]) -> Dictionary[Vector2i, Dictionary]:
	var new_graph : Dictionary[Vector2i, Dictionary]
	for cell in cells:
		var cell_neighbors : Dictionary[Vector2i, int] = _get_cell_neighbors(cell)
		new_graph[cell] = cell_neighbors
	return new_graph

## For each cell in the graph, find its immediate neighbors and assign travel distances to each. 
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
	
## Get the coordinates for the diagonal neighbors of the [Cell] at `cell_coords`.
func _get_diagonal_neighbors(cell_coords: Vector2i) -> Array[Vector2i]: 
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors
#endregion
