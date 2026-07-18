class_name Cell
extends RefCounted

var coords: Vector2i
var neighbors: Array[Dictionary]
var distance: int
var path: Array[Cell]
var is_settled: bool = false
