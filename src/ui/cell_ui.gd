#@tool
#@icon(icon_path: String)
class_name CellUI
extends Control
## Documentation comments

const CELL_ALPHA_FACTOR : float = 0.025

var cell_cost : int:
	set(value):
		cell_cost = value
		cell_cost_label.text = str(cell_cost)
		cell_alpha = float(cell_cost) * CELL_ALPHA_FACTOR

var cell_alpha : float = 0.0:
	set(value):
		cell_alpha = value
		cell_overlay.color.a = cell_alpha

@onready var cell_cost_label: Label = $CellCost
@onready var cell_overlay: ColorRect = $CellOverlay
