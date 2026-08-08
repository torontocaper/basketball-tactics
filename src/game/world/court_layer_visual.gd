#@tool
#@icon(icon_path: String)
class_name CourtLayerVisual
extends CourtLayer
## The visual court layer, responsible for displaying movement distances and paths

const CLICK_INDICATOR = preload("uid://bnm71kxddqynl")
const MAIN_THEME = preload("uid://c0lrucuyge77v")
const PATH_INDICATOR = preload("uid://dkswoobiwgwxy")

var click_indicator : CPUParticles2D
var court_cell_graphics : Dictionary[Vector2i, Dictionary]
var path_indicator : Line2D

#region OVERRIDES
func _ready() -> void:
	super()
	court_cell_graphics = _create_cell_graphics(court_cells)
	click_indicator = CLICK_INDICATOR.instantiate()
	add_child(click_indicator)
	path_indicator = PATH_INDICATOR.instantiate()
	add_child(path_indicator)
	MoveManager.connect("map_updated", update_distances)
	MoveManager.connect("path_found", display_new_path)

func handle_click_at_position(click_position : Vector2, is_right_click : bool):
	super(click_position, is_right_click)
	if _is_cell_in_play(clicked_cell):
		indicate_click(clicked_cell)
#endregion

#region CORE
func display_new_path(new_path : Array) -> void:
	path_indicator.clear_points()
	for point_coords in new_path:
		path_indicator.add_point(map_to_local(point_coords))

func indicate_click(cell_to_indicate : Vector2i) -> void:
	click_indicator.position = map_to_local(cell_to_indicate)
	click_indicator.restart()

func update_distances(dijkstra_map : Dictionary[Vector2i, Dictionary]) -> void:
	path_indicator.clear_points()
	for point in court_cells:
		var point_distance : int = dijkstra_map[point].distance_from_source
		var cell_label : Label = court_cell_graphics.get(point).label
		cell_label.text = str(point_distance)
#endregion

#region PRIVATE/HELPER
func _create_cell_graphics(cells : Array[Vector2i]) -> Dictionary[Vector2i, Dictionary]:
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
