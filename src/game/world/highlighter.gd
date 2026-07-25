#@tool
#@icon(icon_path: String)
class_name Highlighter
extends Line2D
## [Line2D] for displaying a [Cell]'s travel cost

@export var movement_cost: int:
	set(value):
		movement_cost = value
		highlighter_label.text = str(movement_cost)

@onready var highlighter_label: Label = $HighlighterLabel
