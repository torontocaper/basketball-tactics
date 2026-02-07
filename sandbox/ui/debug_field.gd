class_name DebugField
extends HBoxContainer

var target_node: Node
var variable_name: String

@onready var variable_label: Label = $VariableLabel
@onready var value_label: Label = $ValueLabel

func _ready() -> void:
	variable_label.text = variable_name.to_pascal_case() + ": "

func _process(_delta: float) -> void:
	value_label.text = str(target_node.get(variable_name))
