extends Node2D

@export var cell_size: Vector2i = Vector2i(64, 64)
@onready var nav_path: Line2D = $NavPath
@onready var player: Node2D = $PlayerSprite

var astar_grid: AStarGrid2D = AStarGrid2D.new()
var grid_size: Vector2i = Vector2i(16, 14) # Manual grid size (matches court)

var start: Vector2i
var end: Vector2i

var current_path: PackedVector2Array = PackedVector2Array()
var path_index: int = 0
var speed: float = 200.0 # pixels per second

func _ready():
	initialize_grid()
	start = Vector2i.ZERO
	player.position = grid_to_world(start)

func initialize_grid():
	astar_grid.region = Rect2i(Vector2i.ZERO, grid_size)
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

	# 🛠️ Manually make all cells walkable
	for x in grid_size.x:
		for y in grid_size.y:
			var id = Vector2i(x, y)
			astar_grid.set_point_solid(id, false) # Mark cell as walkable

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position
		var grid_click = Vector2i(mouse_pos / Vector2(cell_size))

		if not astar_grid.region.has_point(grid_click):
			print("Click out of bounds: ", grid_click)
			return

		if event.button_index == MOUSE_BUTTON_LEFT:
			start = Vector2i(player.position / Vector2(cell_size)) # Current grid cell
			end = grid_click # Target grid cell
			update_path()

func _process(delta):
	if current_path.size() > 0:
		var target_pos = current_path[path_index]
		var move_vector = (target_pos - player.position).normalized()
		player.position += move_vector * speed * delta

		if player.position.distance_to(target_pos) < 5.0:
			path_index += 1
			if path_index >= current_path.size():
				current_path = PackedVector2Array()
				start = end # Update starting cell after finishing move

func update_path():
	var id_path: Array[Vector2i] = astar_grid.get_id_path(start, end)

	if id_path.is_empty():
		print("No path found!")
		return

	var pixel_path: Array[Vector2] = []

	for id in id_path:
		var world_pos = grid_to_world(id)
		pixel_path.append(world_pos)

	nav_path.points = PackedVector2Array(pixel_path)
	current_path = PackedVector2Array(pixel_path)
	path_index = 0

func grid_to_world(grid: Vector2i) -> Vector2:
	return (Vector2(grid) * Vector2(cell_size)) + (Vector2(cell_size) / 2)
