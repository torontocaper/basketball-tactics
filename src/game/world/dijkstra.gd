#@tool
@icon("uid://cmi5knekkrb06")
class_name Dijkstra
extends Node
## Helper [Node] for implementing Dijkstra's algorithm

func _ready() -> void:
	print_debug("Dijkstra ready at %s ms" % Time.get_ticks_msec())

# Graph of all cells, their immediate neighbors and the cost to reach those neighbors; assigned by CourtMap parent
var graph: Array[Cell]:
	set(value):
		graph = value

func update_graph(source_cell_coords: Vector2i) -> Array[Cell]:
	for node in graph:
		if node.coords == source_cell_coords:
			node.distance = 0
			node.path = [node]
		else:
			node.distance = 99
			node.path = []
		node.is_settled = false
	while graph.any(func(cell): return not cell.is_settled):
		# create priority queue
		graph.sort_custom(func(cell_1, cell_2): return cell_1.distance < cell_2.distance)
		var index_of_closest_unsettled_cell : int = graph.find_custom(func(cell): return not cell.is_settled)
		var closest_unsettled_cell : Cell = graph[index_of_closest_unsettled_cell]
		update_neighbors(closest_unsettled_cell)
	return graph

func update_neighbors(cell: Cell) -> void:
	# Get the cell's immediate neighbors from the graph
	var starting_cell_distance : int = cell.distance
	var starting_cell_path: Array[Cell] = cell.path
	var neighbors : Array[Dictionary] = cell.neighbors
	for neighbor in neighbors:
		var neighbor_coords : Vector2i = neighbor.keys()[0]
		var distance_to_neighbor : int = neighbor[neighbor_coords]
		var index_of_neighbor_cell : int = graph.find_custom(find_neighbor_cell.bind(neighbor_coords)) 
		var neighbor_cell : Cell = graph[index_of_neighbor_cell]
		if neighbor_cell.is_occupied:
			continue
		elif neighbor_cell.distance > starting_cell_distance + distance_to_neighbor:
			neighbor_cell.distance = starting_cell_distance + distance_to_neighbor
			var neighbor_cell_path : Array[Cell] = starting_cell_path.duplicate()
			neighbor_cell_path.append(neighbor_cell)
			neighbor_cell.path = neighbor_cell_path
	cell.is_settled = true

func does_cell_match_coords(cell, cell_to_find_coords: Vector2i) -> bool:
	return cell.coords == cell_to_find_coords

func find_cell_by_coords(coords_of_cell: Vector2i) -> Cell:
	var index_of_cell = graph.find_custom(does_cell_match_coords.bind(coords_of_cell))
	var found_cell: Cell = graph[index_of_cell]
	return found_cell

func find_neighbor_cell(neighbor_cell, potential_neighbor_cell_coords) -> bool:
	return neighbor_cell.coords == potential_neighbor_cell_coords

func get_path_to_cell_by_coords(destination_cell_coords: Vector2i) -> Array[Cell]:
	print_debug("Getting path to cell %s" % destination_cell_coords)
	var destination_cell = find_cell_by_coords(destination_cell_coords)
	var cell_path = destination_cell.path
	return cell_path
