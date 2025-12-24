class_name MyAStar
extends AStarGrid2D

func _compute_cost(from_id: Vector2i, to_id: Vector2i) -> float:
	print_debug("Computing cost from cell %s to %s" % [from_id, to_id])
	pass
