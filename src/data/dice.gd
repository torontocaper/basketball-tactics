extends Node

func roll(d_type: int, d_count: int = 1) -> int:
	print_debug("Dice script rolling %s * d%s" % [d_count, d_type])
	var total: int = 0
	for d in d_count:
		var this_roll: int = randi_range(1, d_type)
		total += this_roll
	return total
