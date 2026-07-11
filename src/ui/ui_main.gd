class_name UIMain
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("UIMain ready at %s ms" % Time.get_ticks_msec())
