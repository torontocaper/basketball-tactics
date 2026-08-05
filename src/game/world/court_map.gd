#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## [TileMapLayer]-based grid of [Cell]s representing the playable area

#const PLAYER_PATH_LINE = preload("uid://blt4mi3f1lmq6")
const MOVEMENT_COST_ORTHOGONAL : int = 2 ## The cost in EnergyPoints for moving to an orthogonal neighbor cell (North, East, South West)
const MOVEMENT_COST_DIAGONAL : int = 3 ## The cost in EnergyPoints for moving to a diagonal neighbor cell (Northeast, Southeast, Southwest, Northwest)

var cells_by_coords: Dictionary[Vector2i, Cell]

#var players: Array[Player]: ## The [Player]s on the court. Assigned by the [Game].
	#set(value):
		#players = value
		#print_debug("CourtMap has %s players" % players.size())
		#for player in players:
			#player.court_map = self
#
#var occupied_cells : Array[Cell]
#var player_path_line : Line2D

var starting_cell_coords: Vector2i:
	set(value):
		starting_cell_coords = value
		MoveManager.update_distances(starting_cell_coords)

#var target_cell_coords: Vector2i:
	#set(value):
		#target_cell_coords = value
		#var destination_cell_path : Array[Cell] = MoveManager.get_path_to_cell_by_coords(target_cell_coords)
		#print_debug("CourtMap has a path: %s" % str(destination_cell_path))
		#highlight_path(destination_cell_path)

func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	child_entered_tree.connect(_set_cell_coords)
	await get_tree().process_frame # Wait one frame so that all child [Cell]s are added to the graph.
	assign_cell_neighbors()
	#MoveManager.create_graph(cells_by_coords)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		var click_global_position : Vector2 = event.global_position
		var click_local_position : Vector2 = to_local(click_global_position)
		var clicked_tile_coords = local_to_map(click_local_position)
		if event.button_index == 1:
			print_debug("CourtMap left-clicked at tile %s" % clicked_tile_coords)
			starting_cell_coords = clicked_tile_coords
		#elif event.button_index == 2:
			#print_debug("CourtMap right-clicked at tile %s" % clicked_tile_coords)
			##target_cell_coords = clicked_tile_coords

## Assign neighbors to each Cell. Best handled here rather than in MoveManager.
func assign_cell_neighbors() -> void:
	for cell_coords in cells_by_coords:
		var cell : Cell = cells_by_coords[cell_coords]
		cell.neighbors = get_cell_neighbors(cell_coords)
		#MoveManager.graph.append(cell)

## For each cell in the graph, find its immediate neighbors and assign travel distances to each. 
## We can't do this in `set_cell_coords` because not all neighbors have been added to the tree yet.
func get_cell_neighbors(cell_coords: Vector2i) -> Array[Dictionary]:
	var neighbors : Array[Dictionary] = []
	var orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(cell_coords) 
	var diagonal_neighbors : Array[Vector2i] = _get_diagonal_neighbors(cell_coords)
	var used_cells : Array[Vector2i] = get_used_cells()
	for o in orthogonal_neighbors:
		if o in used_cells:
			neighbors.append({
				o: MOVEMENT_COST_ORTHOGONAL
			})
	for d in diagonal_neighbors:
		if d in used_cells:
			neighbors.append({
				d: MOVEMENT_COST_DIAGONAL
			})
	return neighbors

## Highlight the path from starting_cell_coords to target_cell_coords
#func highlight_path(path: Array[Cell]) -> void:
	#print_debug("Highlighting path with %s points" % path.size())
	#if player_path_line:
		#player_path_line.clear_points()
	#else:
		#player_path_line = PLAYER_PATH_LINE.instantiate()
	#for cell in path:
		#var cell_coords : Vector2i = cell.coords
		#var local_coords : Vector2 = map_to_local(cell_coords)
		#player_path_line.add_point(local_coords)

## Set the `coords` property for each child [Cell] in the map, and add them to the cells_by_coords Dictionary.
## Triggered by each child_entered_tree signal.
func _set_cell_coords(potential_cell: Node) -> void: 
	if potential_cell is Cell: ## Determine whether the child that's been added is a [Cell]
		var potential_cell_coords : Vector2i = local_to_map(potential_cell.position)
		potential_cell.coords = potential_cell_coords
		cells_by_coords[potential_cell_coords] = potential_cell

## Get the coordinates for the diagonal neighbors of the [Cell] at `cell_coords`.
func _get_diagonal_neighbors(cell_coords: Vector2i) -> Array[Vector2i]: 
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(cell_coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors
