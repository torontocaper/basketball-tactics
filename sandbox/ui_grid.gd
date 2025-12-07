#@tool
#@icon
#class_name
extends Control
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
@export var columns : int
@export var rows : int
@export var cell_size : int
## Regular variables
var court_cell = preload("res://sandbox/court_cell.tscn")
## @onready variables
@onready var grid_container: GridContainer = $GridContainer

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	grid_container.columns = columns
	draw_grid()
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func draw_grid():
	for column in columns:
		print_debug("Starting column %s" % column)
		for row in rows:
			print_debug("Creating a cell at column %s, row %s" % [column, row])
			var cell = court_cell.instantiate()
			cell.custom_minimum_size = Vector2(cell_size, cell_size)
			grid_container.add_child(cell)
## Subclasses
