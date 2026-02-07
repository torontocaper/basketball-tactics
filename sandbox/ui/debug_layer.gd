class_name DebugLayer
extends CanvasLayer

const DEBUG_FIELD = preload("uid://djpuhks8uxo7j")

@export var target: Node
@export var variables_to_track: Array[String]

@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	if target:
		for variable in variables_to_track:
			var debug_field = DEBUG_FIELD.instantiate()
			debug_field.target_node = target
			debug_field.variable_name = variable
			v_box_container.add_child(debug_field)
