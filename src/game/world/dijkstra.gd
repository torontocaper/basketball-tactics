#@tool
#@icon(icon_path: String)
class_name Dijkstra
extends Node
## Helper [Node] for implementing Dijkstra's algorithm

#signal
#enum
#const
#@export var
var graph: Dictionary[Vector2i, Array]:
	set(value):
		graph = value
