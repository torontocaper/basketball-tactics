@icon("uid://cmi5knekkrb06")
extends Node
## Manages movement using Dijkstra's algorithm

#region Signals
## Emitted when the Dijkstra map is updated based on a new source cell
signal map_updated(new_map : Array[Dictionary])

## Emitted when a path is found to a new target cell
signal path_found(new_path : Array[Vector2i], new_path_cost : int)
#endregion

#region Properties
## Static graph of all cells, their immediate neighbors and the costs to reach those neighbors. 
## [br][br]
## Provided by [method CourtLayerData._create_dijkstra_graph]
var dijkstra_graph : Dictionary[Vector2i, Dictionary]

## Dynamic map of all cells, along with their total distances and paths from the source cell, keyed by coords
## [br][br]
## (There is also a key called coords in the value Dictionary, so that the 'values' array contains the coords too)
var distance_map : Dictionary[Vector2i, Dictionary]

## Path for the currently planned move, in map space
## [br][br]
## Must be converted to global space in order for a [Player] to understand it.
## [br][br]
## This occurs in [CourtLayerData] when a target cell is double-clicked
var path_coords : Array

## Cost for the currently planned move
var path_cost : int
#endregion

#region Methods
	#region Core Functionality
## Finds the path from the current source cell to destination_cell_coords
## [br][br]
## Called from [CourtLayerData] when new navigation target is set
func get_move_path(destination_cell_coords : Vector2i) -> void:
	var destination_point : Dictionary = _find_point_by_coords(destination_cell_coords, distance_map)
	path_coords = destination_point.path_from_source
	path_cost = destination_point.distance_from_source
	path_found.emit(path_coords, path_cost)

## Updates the Dijkstra map based on the new source cell
## [br][br]
## Called from [CourtLayerData] when a new source cell is set
func update_map(source_cell_coords: Vector2i, occupied_cells : Dictionary[Player, Vector2i] = {}) -> void:
	# If there's already a dynamic [member distance_map], clear it
	if distance_map:
		distance_map.clear()
	# If the source cell is invalid, do nothing
	# TODO: make this less hack-y
	if source_cell_coords == Vector2i(-1, -1): 
		pass
	# Otherwise, fill in the new map based on the given source_cell_coords
	else:
		for node in dijkstra_graph:
			# First, create a new Dictionary/'point' for each node in the graph
			distance_map[node] = {
				"coords" = node,
				"is_settled" = false,
				"is_occupied" = false,
			}
			# The point on the actual source_cell has a distance of zero and a path of only itself
			# NOTE I'm not sure any of the points need to have the source cell on their path. It may be redundant
			if node == source_cell_coords:
				distance_map[node].distance_from_source = 0
				distance_map[node].path_from_source = [node]
			# Occupied cells are unreachable, so no path is available and the distance is effectively infinite
			elif node in occupied_cells.values():
				distance_map[node].is_occupied = true
				distance_map[node].distance_from_source = 99
				distance_map[node].path_from_source = []
			# All other points start as infinitely far away, with no established path from the source
			else:
				distance_map[node].distance_from_source = 99
				distance_map[node].path_from_source = []
		# Get the values of the distance_map as an Array, so we can sort it
		var map_values : Array[Dictionary] = distance_map.values()
		# While any of the cells are 'unsettled' ...
		while map_values.any(func(point): return not point.is_settled):
			# Create a priority queue by sorting the map_values from lowest distance to highest distance
			map_values.sort_custom(func(point_1, point_2): return point_1.distance_from_source < point_2.distance_from_source)
			# Get the closest 'unsettled' point and update its neighbors
			var index_of_closest_unsettled_point : int = map_values.find_custom(func(point): return not point.is_settled)
			var closest_unsettled_point : Dictionary = map_values[index_of_closest_unsettled_point]
			update_neighbors(closest_unsettled_point.coords, distance_map)
		# Now the whole map is up-to-date based on the source cell. 
		# NOTE Should we remove the entries that are out of range? 
	map_updated.emit(distance_map)

## Update travel distances and paths for the immediate neighbors of a given cell 
func update_neighbors(point_coords: Vector2i, map: Dictionary) -> void:
	# Get the point in the map that corresponds to the provide coords
	var starting_point : Dictionary = _find_point_by_coords(point_coords, map)
	# Get its current distance and path values
	var starting_point_distance : int = starting_point.distance_from_source
	var starting_point_path: Array = starting_point.path_from_source
	# Get the point's immediate neighbors from the dijkstra_graph
	var neighbors : Dictionary = dijkstra_graph[point_coords]
	# For each of those neighbors ...
	for neighbor in neighbors:
		# Get the distance to that neighbor (either 2 or 3) ...
		var distance_to_neighbor : int = neighbors[neighbor]
		# ... find that point in the distance_map ...
		var neighbor_point : Dictionary = _find_point_by_coords(neighbor, map)
		# ... if it's occupied, skip it; otherwise ...
		if neighbor_point.is_occupied:
			continue
		# ... get its potential new distance from the source by adding the starting point's distance from the source with the neighbor's distance from the starting point
		var potential_distance = starting_point_distance + distance_to_neighbor
		# ... if its distance from the source is greater than that value ...
		if neighbor_point.distance_from_source > potential_distance:
			# ... replace its distance with that value ...
			neighbor_point.distance_from_source = potential_distance
			# ... make a new path to this point that's the same as the path to the starting point ...
			var neighbor_point_path : Array = starting_point_path.duplicate()
			# ... then add the coords for this neighbor ...
			neighbor_point_path.append(neighbor_point.coords)
			# ... and set its path from the source to that value
			neighbor_point.path_from_source = neighbor_point_path
		# Once all of a starting point's neighbors are updated, that starting point is 'settled'
		starting_point.is_settled = true
	#endregion

	#region Helpers
## Find a point (complete with path and distance data) given its coordinates
func _find_point_by_coords(coords: Vector2i, map: Dictionary) -> Dictionary:
	var index_of_point = map.values().find_custom(func(point): return point.coords == coords)
	var found_point : Dictionary = map.values()[index_of_point]
	return found_point
	#endregion
#endregion
