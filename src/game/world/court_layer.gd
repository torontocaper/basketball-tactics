#@tool
#@icon(icon_path: String)
class_name CourtLayer
extends TileMapLayer
## A visual or data-based layer of the [Court]. 

#signal
enum LayerType {DATA, VISUAL}
#const
@export var layer_type : LayerType
#@export var
#@onready var

#region OVERRIDES
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		var click_global_position : Vector2 = event.global_position
		var click_local_position : Vector2 = to_local(click_global_position)
		var click_coords = local_to_map(click_local_position)
		handle_click(click_coords)

#endregion

#region CORE
func handle_click(click_coords: Vector2i) -> void:
	match layer_type:
		LayerType.DATA:
			var tile_data = get_cell_tile_data(click_coords)
			for layer_id in tile_set.get_custom_data_layers_count():
				print_debug("Layer id: %s\nLayer name: %s\nLayer value: %s" % [
					str(layer_id),
					str(tile_set.get_custom_data_layer_name(layer_id)), 
					str(tile_data.get_custom_data_by_layer_id(layer_id))
					])
			#var tile_custom_data = tile_data.get_custom_data_by_layer_id(0)
			#var layer_tileset = tile_set
			#var custom_data_layer_name = layer_tileset.get_custom_data_layer_name(0)
			#var custom_data_layer_type = layer_tileset.get_custom_data_layer_type(0)
			#print_debug("This layer has custom data with name %s and type %s" % [custom_data_layer_name, custom_data_layer_type])
		LayerType.VISUAL:
			print_debug("Visual layer clicked")
#endregion

#region PRIVATE/HELPER
#endregion

#region RECEIVERS
#endregion
