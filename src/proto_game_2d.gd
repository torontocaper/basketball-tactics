#@tool
#@icon
#class_name
extends Node2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
var astar_grid: AStarGrid2D
var hovered_cell: Vector2
## @onready variables
@onready var proto_player_2d: AnimatedSprite2D = %ProtoPlayer2d
@onready var court_floor_isometric: CourtFloorIsometric = %CourtFloorIsometric

## Overridden built-in virtual methods
func _ready() -> void:
	astar_grid = _draw_astar_grid()
	court_floor_isometric.set("astar_grid", astar_grid)
	court_floor_isometric.cell_clicked.connect(proto_player_2d.move_along_path)
	
func _process(_delta: float) -> void:
	hovered_cell = court_floor_isometric.local_to_map(get_local_mouse_position())
	court_floor_isometric.set("hovered_cell", hovered_cell)

## Remaining virtual methods
func _draw_astar_grid() -> AStarGrid2D:
	var new_astar_grid = AStarGrid2D.new()
	new_astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_RIGHT
	var cell_size = court_floor_isometric.tile_set.tile_size
	new_astar_grid.cell_size = cell_size
	new_astar_grid.region = court_floor_isometric.get_used_rect()
	new_astar_grid.update()
	return new_astar_grid
## Overridden custom methods
## Remaining methods
## Subclasses
