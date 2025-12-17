class_name CourtFloorIsometric
extends TileMapLayer

@onready var cell_size: Vector2 = tile_set.tile_size

func make_polygon(map_position: Vector2) -> PackedVector2Array:
	var polygon_points = PackedVector2Array([
			Vector2(map_to_local(map_position).x + (cell_size.x / 2), map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y + (cell_size.y / 2)),
			Vector2(map_to_local(map_position).x -(cell_size.x / 2), map_to_local(map_position).y),
			Vector2(map_to_local(map_position).x, map_to_local(map_position).y - (cell_size.y / 2))
	])
	return polygon_points
