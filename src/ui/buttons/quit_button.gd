#@tool
#@icon(icon_path)
class_name QuitButton
extends Button
## Documentation comments

#signal
#enum
#const
#@export var
#var
#@onready var

# OVERRIDES

func _ready():
	print_debug("QuitButton ready at %s ms" % Time.get_ticks_msec())
	_connect_signals()

func _process(_delta):
	pass

func _physics_process(_delta):
	pass

# CORE

# PRIVATE/HELPER
func _connect_signals():
	connect("pressed", _on_quit_button_pressed)

# RECEIVERS
func _on_quit_button_pressed() -> void:
	var tree: SceneTree = get_tree()
	tree.quit()
