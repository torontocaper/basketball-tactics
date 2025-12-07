#@tool
#@icon
#class_name
extends GridContainer
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var rows : int
@export var cell_size : int
@export var timer_length : float = 0.1
## Regular variables
var court_cell = preload("res://sandbox/working/court_cell.tscn")
## @onready variables

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	draw_grid()
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func draw_grid():
	for row in rows:
		print_debug("Starting row %s" % row)
		for column in columns:
			await get_tree().create_timer(timer_length).timeout
			print_debug("Creating a cell at column %s, row %s" % [column, row])
			var cell = court_cell.instantiate()
			cell.custom_minimum_size = Vector2(cell_size, cell_size)
			cell.set("cell_coords", Vector2i(column, row))
			add_child(cell)
## Subclasses
