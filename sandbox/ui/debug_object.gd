class_name DebugObject
extends VBoxContainer

const DEBUG_FIELD = preload("uid://djpuhks8uxo7j")

@export var target_object: Node
@export var target_variables: Array[StringName]

@onready var title_label: Label = $TitleLabel

func _ready() -> void:
	if target_object:
		title_label.text = "Debug info for %s" % target_object.name.to_upper()
		for variable in target_variables:
			var debug_field := DEBUG_FIELD.instantiate()
			debug_field.target_node = target_object
			debug_field.variable_name = variable
			add_child(debug_field)
