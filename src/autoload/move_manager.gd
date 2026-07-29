@icon("uid://cmi5knekkrb06")
extends Node
## Manages movement using Dijkstra's algorithm

## Graph of all cells, their immediate neighbors and the costs to reach those neighbors; assigned by CourtMap parent
var graph: Array[Cell]

#region Core functionality
func update_distances(source_cell_coords: Vector2i) -> void:
	print_debug("Creating a Dijkstra map with source cell at coords %s" % source_cell_coords)
	var new_dijkstra_map : Array[DijkstraPoint] = []
	for node in graph:
		var new_dijkstra_point : DijkstraPoint = DijkstraPoint.new(node)
		if node.coords == source_cell_coords:
			new_dijkstra_point.distance = 0
			#new_dijkstra_point.path = [node]
		else:
			new_dijkstra_point.distance = 99
			#new_dijkstra_point.path = []
		new_dijkstra_map.append(new_dijkstra_point)
	print_debug("Dijkstra Map created with %s points" % new_dijkstra_map.size())
	while new_dijkstra_map.any(func(cell): return not cell.is_settled):
		# create priority queue
		new_dijkstra_map.sort_custom(func(cell_1, cell_2): return cell_1.distance < cell_2.distance)
		var index_of_closest_unsettled_point : int = new_dijkstra_map.find_custom(func(cell): return not cell.is_settled)
		var closest_unsettled_point : DijkstraPoint = new_dijkstra_map[index_of_closest_unsettled_point]
		update_neighbors(closest_unsettled_point, new_dijkstra_map)

func update_neighbors(d_p: DijkstraPoint, d_m: Array[DijkstraPoint]) -> void:
	# Get the cell's immediate neighbors from the graph
	var starting_point_distance : int = d_p.distance
	#var starting_point_path: Array[Cell] = d_p.path
	var neighbors : Array[Dictionary] = d_p.cell.neighbors
	for neighbor in neighbors:
		var neighbor_coords : Vector2i = neighbor.keys()[0]
		var distance_to_neighbor : int = neighbor[neighbor_coords]
		#var index_of_neighbor_cell : int = graph.find_custom(find_neighbor_cell.bind(neighbor_coords)) 
		var neighbor_point : DijkstraPoint = find_dp_by_coords(neighbor_coords, d_m)
		#var neighbor_cell : Cell = graph[index_of_neighbor_cell]
		if neighbor_point.cell.is_occupied:
			continue
		elif neighbor_point.distance > starting_point_distance + distance_to_neighbor:
			neighbor_point.distance = starting_point_distance + distance_to_neighbor
			#var neighbor_point_path : Array[Cell] = starting_point_path.duplicate()
			#neighbor_point_path.append(neighbor_point.cell)
			#neighbor_point.path = neighbor_point_path
		d_p.cell.set_movement_cost(starting_point_distance)
		d_p.is_settled = true
#endregion

func does_dp_match_coords(d_p : DijkstraPoint, dp_to_find_coords: Vector2i) -> bool:
	return d_p.cell_coords == dp_to_find_coords

func find_dp_by_coords(coords: Vector2i, d_m: Array[DijkstraPoint]) -> DijkstraPoint:
	var index_of_dp = d_m.find_custom(does_dp_match_coords.bind(coords))
	var found_dp : DijkstraPoint = d_m[index_of_dp]
	return found_dp

func find_neighbor_cell(neighbor_cell, potential_neighbor_cell_coords) -> bool:
	return neighbor_cell.coords == potential_neighbor_cell_coords

#func get_path_to_cell_by_coords(destination_cell_coords: Vector2i) -> Array[Cell]:
	#print_debug("Getting path to cell %s" % destination_cell_coords)
	#var destination_cell = find_cell_by_coords(destination_cell_coords)
	#var cell_path = destination_cell.path
	#return cell_path

class DijkstraPoint:
	var cell : Cell
	var cell_coords : Vector2i
	#var neighbors : Array[Dictionary]
	var distance : int
	#var path : Array[Cell]
	var is_settled : bool = false
	func _init(c: Cell) -> void:
		cell = c
		cell_coords = cell.coords
