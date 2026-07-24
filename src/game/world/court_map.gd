#@tool
#@icon(icon_path: String)
class_name CourtMap
extends TileMapLayer
## [TileMapLayer]-based grid of [Cell]s representing the playable area

const HIGHLIGHTER = preload("uid://8g0gamnv6cvn")

const MOVEMENT_COST_ORTHOGONAL : int = 2
const MOVEMENT_COST_DIAGONAL : int = 3

var all_cells: Array[Vector2i]

var players_on_court: Array[Player]:
	set(value):
		players_on_court = value
		print_debug("CourtMap has %s players" % players_on_court.size())
		for player in players_on_court:
			player.court_map = self
		set_occupied_cells(players_on_court)

var updated_graph: Array[Cell]:
	set(value):
		updated_graph = value
		clear_highlights()
		player_path_line.clear_points()
		for cell in updated_graph:
			highlight_cell(cell)

var occupied_cells: Array[Cell]

var destination_cell: Vector2i:
	set(value):
		destination_cell = value
		var destination_cell_path : Array[Cell] = dijkstra.get_path_to_cell_by_coords(destination_cell)
		print_debug("CourtMap has a path: %s" % str(destination_cell_path))
		highlight_path(destination_cell_path)

var starting_cell: Vector2i:
	set(value):
		starting_cell = value
		updated_graph = dijkstra.update_graph(starting_cell)

@onready var player_path_line: Line2D = $PlayerPathLine
@onready var dijkstra: Dijkstra = $Dijkstra

# OVERRIDES
func _ready() -> void:
	print_debug("CourtMap ready at %s ms" % Time.get_ticks_msec())
	child_entered_tree.connect(set_cell_coords)
	all_cells = get_used_cells()
	await get_tree().process_frame
	dijkstra.graph = create_graph()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		var click_global_position : Vector2 = event.global_position
		var click_local_position : Vector2 = to_local(click_global_position)
		var clicked_tile_coords = local_to_map(click_local_position)
		if event.button_index == 1:
			print_debug("CourtMap left-clicked at tile %s" % clicked_tile_coords)
			starting_cell = clicked_tile_coords
		elif event.button_index == 2:
			print_debug("CourtMap right-clicked at tile %s" % clicked_tile_coords)
			destination_cell = clicked_tile_coords

func set_cell_coords(potential_cell: Node) -> void:
	if potential_cell is Cell:
		#print_debug("%s with position %s has entered the tree" % [potential_cell.name, potential_cell.position])
		potential_cell.coords = local_to_map(potential_cell.position)
		print_debug("%s with coords %s has entered the tree" % [potential_cell.name, potential_cell.coords])

func create_graph() -> Array[Cell]:
	var children : Array[Node] = get_children()
	var new_graph : Array[Cell]
	for child in children:
		if child is Cell:
			#child.coords = local_to_map(child.position)
			child.neighbors = get_cell_neighbors(child.coords)
			new_graph.append(child)
	return new_graph

func get_cell_neighbors(cell: Vector2i) -> Array[Dictionary]:
	var neighbors : Array[Dictionary] = []
	var orthogonal_neighbors : Array[Vector2i] = get_surrounding_cells(cell) 
	var diagonal_neighbors : Array[Vector2i] = get_diagonal_neighbors(cell)
	for o in orthogonal_neighbors:
		if o in all_cells:
			neighbors.append({
				o: MOVEMENT_COST_ORTHOGONAL
			})
	for d in diagonal_neighbors:
		if d in all_cells:
			neighbors.append({
				d: MOVEMENT_COST_DIAGONAL
			})
	return neighbors

func get_diagonal_neighbors(coords: Vector2i) -> Array[Vector2i]:
	var diagonal_neighbors : Array[Vector2i] = [
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER),
		get_neighbor_cell(coords, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
		]
	return diagonal_neighbors

func highlight_cell(cell_to_highlight: Cell) -> void:
	var new_highlighter : Highlighter = HIGHLIGHTER.instantiate()
	new_highlighter.movement_cost = cell_to_highlight.distance
	new_highlighter.position = map_to_local(cell_to_highlight.coords)
	add_child(new_highlighter)

func highlight_path(path: Array[Cell]) -> void:
	print_debug("Highlighting path with %s points" % path.size())
	player_path_line.clear_points()
	#queue_redraw()
	for cell in path:
		var cell_coords : Vector2i = cell.coords
		var local_coords : Vector2 = map_to_local(cell_coords)
		print_debug("Adding cell %s with coords %s to the path" % [cell_coords, local_coords])
		player_path_line.add_point(map_to_local(cell.coords))

func clear_highlights() -> void:
	for child in get_children():
		if child is Highlighter:
			child.queue_free()

func set_occupied_cells(players: Array[Player]) -> Array[Cell]:
	var cells: Array[Cell]
	print_stack()
	for player in players:
		var player_local_position = to_local(player.global_position)
		var player_cell_coords: Vector2i = local_to_map(player_local_position)
		var occupied_cell : Cell = dijkstra.find_cell_by_coords(player_cell_coords)
		occupied_cell.occupying_player = player
		player.current_cell = occupied_cell
		cells.append(occupied_cell)
	return cells
