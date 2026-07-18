#@tool
@icon("uid://cmi5knekkrb06")
class_name Dijkstra
extends Node
## Helper [Node] for implementing Dijkstra's algorithm

@export var cell_to_check : Vector2i = Vector2i(0, 0) # For testing; easily manipulated from editor

# Graph of all cells, their immediate neighbors and the cost to reach those neighbors; assigned by CourtMap parent
var graph: Array[Cell]:
	set(value):
		graph = value
		get_cell_data(cell_to_check)

var cells: Array[Cell]

func get_cell_data(source_cell: Vector2i) -> void:
	print_debug("Getting cell data with source cell %s" % source_cell)

	for node in graph:
		if node.coords == source_cell:
			node.distance = 0
		else:
			node.distance = 999
		node.path = []
		cells.append(node)

	while cells.any(is_unsettled.bind()):
		# create priority queue
		cells.sort_custom(func(cell_1, cell_2): return cell_1.distance < cell_2.distance)
		var index_of_unsettled_cell_with_lowest_distance : int = cells.find_custom(is_unsettled.bind())
		var unsettled_cell_with_lowest_distance : Cell = cells[index_of_unsettled_cell_with_lowest_distance]
		update_neighbors(unsettled_cell_with_lowest_distance)
		unsettled_cell_with_lowest_distance.is_settled = true

func is_unsettled(cell: Cell) -> bool:
	return not cell.is_settled
#func sort_cells_by_distance(cell_1, cell_2) -> bool:
	#return cell_1.distance < cell_2.distance
	##var starting_cell = source_cell
#
	#while settled_cells.size() < graph.size():
		## Find the cell(s?) with the lowest current travel cost from the source cell
		#var starting_cell_cost : int = unsettled_cells[starting_cell].cost
		#var starting_cell_path : Array = unsettled_cells[starting_cell].path
		#update_neighbors(starting_cell, starting_cell_cost)
		#settled_cells[starting_cell] = {
			#"cost": starting_cell_cost,
			#"path": starting_cell_path
		#}
		#unsettled_cells.erase(starting_cell)
		#print_debug("unsettled_cells: %s" % unsettled_cells)
		#await get_tree().create_timer(0.1).timeout
		#if unsettled_cells.size() > 0:
			#starting_cell = create_priority_queue(unsettled_cells)[0]

	#print_debug("settled_cells: %s" % settled_cells)

#func create_priority_queue(cells: Array[Cell]) -> Array[Vector2i]:
	#var sorted_cells : Array[Cell] = cells.sort_custom(sort_cells_by_distance)
	##print_debug("Unsorted queue: %s" % str(queue))
	##queue.sort_custom(sort_keys)
	##print_debug("Sorted queue: %s" % str(queue))
	#return sorted_cells


func update_neighbors(cell: Cell) -> void:
	# Get the cell's immediate neighbors from the graph
	var starting_cell_distance : int = cell.distance
	var neighbors : Array[Dictionary] = cell.neighbors
	for neighbor in neighbors:
		var neighbor_coords : Vector2i = neighbor.keys()[0]
		var distance_to_neighbor : int = neighbor[neighbor_coords]
		var index_of_neighbor_cell : int = cells.find_custom(find_neighbor_cell.bind(neighbor_coords)) 
		var neighbor_cell : Cell = cells[index_of_neighbor_cell]
		if neighbor_cell.distance > starting_cell_distance + distance_to_neighbor:
			neighbor_cell.distance = starting_cell_distance + distance_to_neighbor
			neighbor_cell.path.append(neighbor_cell)
		
			#if unsettled_cells[neighbor_coords].cost > base_cost + cost_to_visit:
				#unsettled_cells[neighbor_coords].cost = base_cost + cost_to_visit
				##unsettled_cells[neighbor_coords].path.pop_back()
				#unsettled_cells[neighbor_coords].path.append(neighbor_coords)

func find_neighbor_cell(neighbor_cell, potential_neighbor_cell_coords) -> bool:
	return neighbor_cell.coords == potential_neighbor_cell_coords
