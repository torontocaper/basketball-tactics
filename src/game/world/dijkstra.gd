#@tool
@icon("uid://cmi5knekkrb06")
class_name Dijkstra
extends Node
## Helper [Node] for implementing Dijkstra's algorithm

@export var node_to_check : Vector2i = Vector2i(0, 0) # For testing; easily manipulated from editor

# Graph of all cells, their immediate neighbors and the cost to reach those neighbors; assigned by CourtMap parent
var graph: Dictionary[Vector2i, Array]:
	set(value):
		graph = value
		get_travel_costs_and_paths(node_to_check)

var unsettled_nodes: Dictionary[Vector2i, Dictionary]
var settled_nodes: Dictionary[Vector2i, Dictionary]

func get_travel_costs_and_paths(source_node: Vector2i) -> void:
	print_debug("Getting travel costs and paths for %s" % source_node)

	# Set every unvisited node's cost/distance as INF
	for node in graph:
		unsettled_nodes[node] = {
			"cost": INF,
			"path": []
		}

	# We know it costs nothing to reach the source
	unsettled_nodes[source_node] = {
		"cost": 0,
		"path": []
	}

	var starting_node = source_node

	while settled_nodes.size() < graph.size():
		# Find the node(s?) with the lowest current travel cost from the source node
		var current_node_cost : int = unsettled_nodes[starting_node].cost
		var current_node_path : Array = unsettled_nodes[starting_node].path
		update_neighbors(starting_node, current_node_cost)
		settled_nodes[starting_node] = {
			"cost": current_node_cost,
			"path": current_node_path
		}
		unsettled_nodes.erase(starting_node)
		print_debug("unsettled_nodes: %s" % unsettled_nodes)
		await get_tree().create_timer(0.1).timeout
		if unsettled_nodes.size() > 0:
			starting_node = create_priority_queue(unsettled_nodes)[0]
		# Visit its neighbors
		#visit_neighbors(next_node_to_visit)
	
	print_debug("settled_nodes: %s" % settled_nodes)

func create_priority_queue(unvisited: Dictionary[Vector2i, Dictionary]) -> Array[Vector2i]:
	var queue : Array[Vector2i] = unvisited.keys()
	#print_debug("Unsorted queue: %s" % str(queue))
	queue.sort_custom(sort_keys)
	#print_debug("Sorted queue: %s" % str(queue))
	return queue

func sort_keys(key_1, key_2) -> bool:
	var key_1_cost = unsettled_nodes[key_1].cost
	var key_2_cost = unsettled_nodes[key_2].cost
	return key_1_cost < key_2_cost

func update_neighbors(node: Vector2i, base_cost: int) -> void:
	var neighbors : Array[Dictionary] = graph[node]
	for neighbor in neighbors:
		var neighbor_coords : Vector2i = neighbor.keys()[0]
		var cost_to_visit : int = neighbor[neighbor_coords]
		if neighbor_coords in unsettled_nodes:
			if unsettled_nodes[neighbor_coords].cost > base_cost + cost_to_visit:
				unsettled_nodes[neighbor_coords].cost = base_cost + cost_to_visit
				#unsettled_nodes[neighbor_coords].path.pop_back()
				unsettled_nodes[neighbor_coords].path.append(neighbor_coords)
		
	# We want the result to look something like this:
	#{
	#(1, 0):
		#"cost" = 2
		#"path" = [(1, 0)]
	#(1, 1): 3, [(1, 1)]
	#(1, 2): 5, [(1, 1), (1, 2)]
	#}
