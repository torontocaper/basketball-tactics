@tool
class_name SimplePlayer
extends TextureRect

#@export var player_sprite : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#texture.atlas = player_sprite
	pass ## TODO figure out how to set size based on cell_size of courtgrid


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
