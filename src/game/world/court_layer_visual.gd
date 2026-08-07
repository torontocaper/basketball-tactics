#@tool
#@icon(icon_path: String)
class_name CourtLayerVisual
extends CourtLayer
## Documentation comments

#signal
#enum
#const
const CLICK_INDICATOR = preload("uid://bnm71kxddqynl")
const MAIN_THEME = preload("uid://c0lrucuyge77v")
#@export var
var court_cell_graphics : Dictionary[Vector2i, Dictionary]
var indicator : CPUParticles2D
#@onready var

#region OVERRIDES
func _ready() -> void:
	super()
	court_cell_graphics = _create_graphics(court_cells)
	indicator = CLICK_INDICATOR.instantiate()
	add_child(indicator)
	MoveManager.connect("map_updated", update_distances)

func handle_click_at_position(click_position):
	super(click_position)
	if _is_tile_in_play(clicked_cell):
		indicate_click()
#endregion

#region CORE
func update_distances(dijkstra_map : Dictionary[Vector2i, Dictionary]) -> void:
	for point in court_cells:
		var point_distance : int = dijkstra_map[point].distance_from_source
		var cell_label : Label = court_cell_graphics.get(point).label
		cell_label.text = str(point_distance)

func indicate_click() -> void:
	indicator.position = map_to_local(clicked_cell)
	indicator.restart()
#endregion

#region PRIVATE/HELPER
func _create_graphics(cells : Array[Vector2i]) -> Dictionary[Vector2i, Dictionary]:
	var graphics : Dictionary[Vector2i, Dictionary] = {}
	for cell in cells:
		graphics[cell] = {}
		var cell_label : Label = Label.new()
		cell_label.name = "label_%s_%s" % [str(cell.x), str(cell.y)]
		cell_label.theme = MAIN_THEME
		cell_label.position = map_to_local(cell)
		cell_label.offset_transform_enabled = true
		cell_label.offset_transform_position_ratio = Vector2(-0.5, -0.5)
		cell_label.z_index = 100
		add_child(cell_label)
		graphics[cell].label = cell_label
	return graphics
#endregion

#region RECEIVERS
#endregion
