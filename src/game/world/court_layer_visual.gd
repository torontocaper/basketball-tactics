#@tool
#@icon(icon_path: String)
class_name CourtLayerVisual
extends CourtLayer
## Documentation comments

#signal
#enum
#const
const CLICK_INDICATOR = preload("uid://bnm71kxddqynl")
#@export var
#var
#@onready var

#region OVERRIDES
func _ready() -> void:
	MoveManager.connect("map_updated", display_distances)

func handle_click_at_position(click_position):
	super(click_position)
	if _is_tile_in_play(clicked_cell):
		indicate_click()
#endregion

#region CORE
func display_distances(dijkstra_map : Dictionary[Vector2i, Dictionary]) -> void:
	print_debug("%s displaying updated distances" % name)
	for point in dijkstra_map:
		var point_distance : int = dijkstra_map[point].distance_from_source
		var new_label : Label = Label.new()
		new_label.text = str(point_distance)
		new_label.position = map_to_local(point)
		new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_label.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(new_label)
		#print_debug("%s distance: %s" % [point, dijkstra_map[point].distance_from_source])

func indicate_click() -> void:
	var new_indicator : CPUParticles2D = CLICK_INDICATOR.instantiate()
	new_indicator.position = map_to_local(clicked_cell)
	add_child(new_indicator)
	new_indicator.emitting = true
	await new_indicator.finished
	new_indicator.queue_free()
#endregion

#region PRIVATE/HELPER
#endregion

#region RECEIVERS
#endregion
