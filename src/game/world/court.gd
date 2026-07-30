@icon("uid://dg3f18xvus5g0")
class_name Court
extends Node2D
## The surface a [Game] is played on.

@onready var visual_layer: CourtLayer = $VisualLayer
@onready var data_layer: CourtLayer = $DataLayer

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_pressed() and event is InputEventMouseButton:
		#var click_global_position : Vector2 = event.global_position
		#var click_local_position : Vector2 = to_local(click_global_position)
		#var clicked_tile_coords = data_layer.local_to_map(click_local_position)
		#if event.button_index == 1:
			#print_debug("Court left-clicked at tile %s" % clicked_tile_coords)
		#get_values(clicked_tile_coords)
#
#func get_values(coords: Vector2i) -> void:
	#for layer in layers:
		#var layer_type : CourtLayer.LayerType = layer.layer_type
		#match layer_type:
			#CourtLayer.LayerType.DATA:
				#print_debug("%s is a data layer" % layer.name)
				#var tile_data = layer.get_cell_tile_data(coords)
				#if tile_data.get_custom_data_by_layer_id(0):
					#var tile_custom_data = tile_data.get_custom_data_by_layer_id(0)
					#var layer_tileset = layer.tile_set
					#var custom_data_layer_name = layer_tileset.get_custom_data_layer_name(0)
					#var custom_data_layer_type = layer_tileset.get_custom_data_layer_type(0)
					#print_debug("This layer has custom data with name %s and type %s" % [custom_data_layer_name, custom_data_layer_type])
			#CourtLayer.LayerType.NAVIGATION:
				#print_debug("%s is a nav layer" % layer.name)
			#CourtLayer.LayerType.VISUAL:
				#print_debug("%s is a visual layer" % layer.name)
