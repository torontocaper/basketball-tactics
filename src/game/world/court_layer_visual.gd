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
#endregion

#region CORE
func handle_click_at_position(click_position):
	super(click_position)
	if _is_tile_in_play(clicked_cell):
		indicate_click()

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
