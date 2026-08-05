@icon("uid://cmi5knekkrb06")
extends Node
## Manages movement using Dijkstra's algorithm

signal map_updated(new_map: Array[Dictionary])

## Graph of all cells, their immediate neighbors and the costs to reach those neighbors; assigned by CourtLayerData
var graph : Dictionary[Vector2i, Dictionary]
## Map of all cells and their total distances from the source cell
var distance_map : Dictionary[Vector2i, Dictionary]

#region Core functionality
func update_map(source_cell_coords: Vector2i) -> void:
	print_debug("MoveManager creating a Dijkstra map with source cell at coords %s" % source_cell_coords)
	if distance_map:
		distance_map.clear()
	for node in graph:
		distance_map[node] = {
			"coords" = node,
			"is_settled" = false
		}
		#distance_map[node].coords = node
		#distance_map[node].is_settled = false
		if node == source_cell_coords:
			distance_map[node].distance_from_source = 0
			##new_dijkstra_point.path = [node]
		else:
			distance_map[node].distance_from_source = 99
			##new_dijkstra_point.path = []
	var map_values : Array[Dictionary] = distance_map.values()
	while map_values.any(func(point): return not point.is_settled):
		## create priority queue
		map_values.sort_custom(func(point_1, point_2): return point_1.distance_from_source < point_2.distance_from_source)
		var index_of_closest_unsettled_point : int = map_values.find_custom(func(point): return not point.is_settled)
		var closest_unsettled_point : Dictionary = map_values[index_of_closest_unsettled_point]
		update_neighbors(closest_unsettled_point.coords, map_values)
		map_values = distance_map.values()
	#return distance_map

func update_neighbors(dijkstra_point_coords: Vector2i, dijkstra_map: Array[Dictionary]) -> void:
	## Get the cell's immediate neighbors from the graph
	var starting_point : Dictionary = find_dp_by_coords(dijkstra_point_coords, dijkstra_map)
	var starting_point_distance : int = starting_point.distance_from_source
	#var starting_point_path: Array[Cell] = d_p.path
	var neighbors : Dictionary = graph[dijkstra_point_coords]
	for neighbor in neighbors:
		var distance_to_neighbor : int = neighbors[neighbor]
		var neighbor_point : Dictionary = find_dp_by_coords(neighbor, dijkstra_map)
		#if neighbor_point.cell.is_occupied:
			#continue
		if neighbor_point.distance_from_source > starting_point_distance + distance_to_neighbor:
			neighbor_point.distance_from_source = starting_point_distance + distance_to_neighbor
			#var neighbor_point_path : Array[Cell] = starting_point_path.duplicate()
			#neighbor_point_path.append(neighbor_point.cell)
			#neighbor_point.path = neighbor_point_path
		starting_point.is_settled = true
#endregion

func does_dp_match_coords(dijkstra_point : Dictionary, dp_to_find_coords: Vector2i) -> bool:
	return dijkstra_point.coords == dp_to_find_coords

func find_dp_by_coords(coords: Vector2i, dijkstra_map: Array[Dictionary]) -> Dictionary:
	var index_of_dp = dijkstra_map.find_custom(does_dp_match_coords.bind(coords))
	var found_dp : Dictionary = dijkstra_map[index_of_dp]
	return found_dp

#func find_neighbor_cell(neighbor_cell, potential_neighbor_cell_coords) -> bool:
	#return neighbor_cell.coords == potential_neighbor_cell_coords

#func get_path_to_cell_by_coords(destination_cell_coords: Vector2i) -> Array[Cell]:
	#print_debug("Getting path to cell %s" % destination_cell_coords)
	#var destination_cell = find_cell_by_coords(destination_cell_coords)
	#var cell_path = destination_cell.path
	#return cell_path

func handle_click(click_coords : Vector2i) -> void:
	print("MoveManager handling click on tile %s" % str(click_coords))
	update_map(click_coords)
	map_updated.emit(distance_map)

#class DijkstraPoint:
	#var coords : Vector2i
	#var distance_from_source : int
	#var is_settled : bool = false
	##var path : Array[Cell]
	#func _init(point_coords: Vector2i) -> void:
		#coords = point_coords
