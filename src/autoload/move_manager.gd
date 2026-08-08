@icon("uid://cmi5knekkrb06")
extends Node
## Manages movement using Dijkstra's algorithm

signal map_updated(new_map: Array[Dictionary])
signal path_found(new_path: Array[Vector2i])

## Graph of all cells, their immediate neighbors and the costs to reach those neighbors
var graph : Dictionary[Vector2i, Dictionary]
## Map of all cells and their total distances from the source cell
var distance_map : Dictionary[Vector2i, Dictionary]

#region CORE
## Finds the path from the current source cell to [member destination_cell_coords]
func get_path_by_coords(destination_cell_coords : Vector2i) -> void:
	print_debug("Getting path to cell %s" % destination_cell_coords)
	var destination_point : Dictionary = _find_point_by_coords(destination_cell_coords, distance_map.values())
	var path_coords : Array = destination_point.path_from_source
	path_found.emit(path_coords)

## Update the Dijkstra map based on the new source cell
func update_map(source_cell_coords: Vector2i) -> void:
	print_debug("MoveManager creating a Dijkstra map with source cell at coords %s" % source_cell_coords)
	if distance_map:
		distance_map.clear()
	for node in graph:
		distance_map[node] = {
			"coords" = node,
			"is_settled" = false
		}
		if node == source_cell_coords:
			distance_map[node].distance_from_source = 0
			distance_map[node].path_from_source = [node]
		else:
			distance_map[node].distance_from_source = 99
			distance_map[node].path_from_source = []
	var map_values : Array[Dictionary] = distance_map.values()
	while map_values.any(func(point): return not point.is_settled):
		# create priority queue
		map_values.sort_custom(func(point_1, point_2): return point_1.distance_from_source < point_2.distance_from_source)
		var index_of_closest_unsettled_point : int = map_values.find_custom(func(point): return not point.is_settled)
		var closest_unsettled_point : Dictionary = map_values[index_of_closest_unsettled_point]
		update_neighbors(closest_unsettled_point.coords, map_values)
		map_values = distance_map.values()
	map_updated.emit(distance_map)

## Update travel distances and paths for the immediate neighbors of a given cell 
func update_neighbors(point_coords: Vector2i, map: Array[Dictionary]) -> void:
	# Get the cell's immediate neighbors from the graph
	var starting_point : Dictionary = _find_point_by_coords(point_coords, map)
	var starting_point_distance : int = starting_point.distance_from_source
	var starting_point_path: Array = starting_point.path_from_source
	var neighbors : Dictionary = graph[point_coords]
	for neighbor in neighbors:
		var distance_to_neighbor : int = neighbors[neighbor]
		var neighbor_point : Dictionary = _find_point_by_coords(neighbor, map)
		#if neighbor_point.cell.is_occupied:
			#continue
		if neighbor_point.distance_from_source > starting_point_distance + distance_to_neighbor:
			neighbor_point.distance_from_source = starting_point_distance + distance_to_neighbor
			var neighbor_point_path : Array = starting_point_path.duplicate()
			neighbor_point_path.append(neighbor_point.coords)
			neighbor_point.path_from_source = neighbor_point_path
		starting_point.is_settled = true
#endregion

#region PRIVATE/HELPER
func _find_point_by_coords(coords: Vector2i, map: Array[Dictionary]) -> Dictionary:
	var index_of_point = map.find_custom(func(point): return point.coords == coords)
	var found_point : Dictionary = map[index_of_point]
	return found_point
#endregion

#func find_neighbor_cell(neighbor_cell, potential_neighbor_cell_coords) -> bool:
	#return neighbor_cell.coords == potential_neighbor_cell_coords
