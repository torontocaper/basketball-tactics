@icon("uid://cmi5knekkrb06")
extends Node
## Manages movement using Dijkstra's algorithm

## Graph of all cells, their immediate neighbors and the costs to reach those neighbors; assigned by CourtLayerData
var graph : Dictionary[Vector2i, Dictionary]
var map : Array[DijkstraPoint]

#region Core functionality
func update_distances(source_cell_coords: Vector2i) -> void:
	print_debug("MoveManager creating a Dijkstra map with source cell at coords %s" % source_cell_coords)
	if map:
		map.clear()
	for node in graph:
		var new_dijkstra_point : DijkstraPoint = DijkstraPoint.new(node)
		if new_dijkstra_point.coords == source_cell_coords:
			new_dijkstra_point.distance_from_source = 0
			##new_dijkstra_point.path = [node]
		else:
			new_dijkstra_point.distance_from_source = 99
			##new_dijkstra_point.path = []
		map.append(new_dijkstra_point)
	while map.any(func(point): return not point.is_settled):
		## create priority queue
		map.sort_custom(func(point_1, point_2): return point_1.distance_from_source < point_2.distance_from_source)
		var index_of_closest_unsettled_point : int = map.find_custom(func(point): return not point.is_settled)
		var closest_unsettled_point : DijkstraPoint = map[index_of_closest_unsettled_point]
		update_neighbors(closest_unsettled_point.coords, map)

func update_neighbors(d_p_coords: Vector2i, d_m: Array[DijkstraPoint]) -> void:
	## Get the cell's immediate neighbors from the graph
	var starting_point : DijkstraPoint = find_dp_by_coords(d_p_coords, d_m)
	var starting_point_distance : int = starting_point.distance_from_source
	#var starting_point_path: Array[Cell] = d_p.path
	var neighbors : Dictionary = graph[d_p_coords]
	for neighbor in neighbors:
		var distance_to_neighbor : int = neighbors[neighbor]
		var neighbor_point : DijkstraPoint = find_dp_by_coords(neighbor, d_m)
		#if neighbor_point.cell.is_occupied:
			#continue
		if neighbor_point.distance_from_source > starting_point_distance + distance_to_neighbor:
			neighbor_point.distance_from_source = starting_point_distance + distance_to_neighbor
			#var neighbor_point_path : Array[Cell] = starting_point_path.duplicate()
			#neighbor_point_path.append(neighbor_point.cell)
			#neighbor_point.path = neighbor_point_path
		starting_point.is_settled = true
#endregion

func does_dp_match_coords(d_p : DijkstraPoint, dp_to_find_coords: Vector2i) -> bool:
	return d_p.coords == dp_to_find_coords

func find_dp_by_coords(coords: Vector2i, d_m: Array[DijkstraPoint]) -> DijkstraPoint:
	var index_of_dp = d_m.find_custom(does_dp_match_coords.bind(coords))
	var found_dp : DijkstraPoint = d_m[index_of_dp]
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
	update_distances(click_coords)

class DijkstraPoint:
	var coords : Vector2i
	var distance_from_source : int
	var is_settled : bool = false
	#var path : Array[Cell]
	func _init(point_coords: Vector2i) -> void:
		coords = point_coords
