extends Control

@export var player_sprite : Sprite2D

@export var textures : Array[Texture2D] # Allows adding spritesheets to the gallery

func _on_idle_button_pressed() -> void:
	player_sprite.get_child(0).play("idle")

func _on_run_button_pressed() -> void:
	player_sprite.get_child(0).play("run")

func _on_stop_button_pressed() -> void:
	player_sprite.get_child(0).stop()

func _on_texture_button_pressed() -> void:
	player_sprite.texture = textures.pick_random()
