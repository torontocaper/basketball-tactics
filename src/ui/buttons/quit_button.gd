#@tool
#@icon(icon_path)
class_name QuitButton
extends Button
## Documentation comments

# OVERRIDES
func _ready():
	print_debug("QuitButton ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

# PRIVATE/HELPER
func _connect_signals():
	connect("pressed", _on_quit_button_pressed)

# RECEIVERS
func _on_quit_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.quit()
