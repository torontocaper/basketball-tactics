#@tool
#@icon(icon_path: String)
#class_name Screenshot
extends Node
## Screenshot functionality

#signal
#enum
#const
#@export var
#var
#@onready var

# OVERRIDES
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("screenshot"):
		capture_screenshot()

func capture_screenshot() -> void:
	var image = get_viewport().get_texture().get_image()
	var prefix: String = Time.get_date_string_from_system() 
	var suffix: String = str(randi_range(0, 9))
	image.save_png("res://docs/screenshots/%s-screenshot-%s.png" % [prefix, suffix])
