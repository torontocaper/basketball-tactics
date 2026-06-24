@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
#enum
#const

## Whether the player is currently in possession of the ball.
@export var has_ball: bool = false:
	set(value):
		if not is_node_ready():
			await ready
		has_ball_sprite.visible = value

## Whether it's this player's turn.
@export var is_active: bool = false: 
	set(value):
		if not is_node_ready():
			await ready
		is_active = value
		active_sprite.visible = is_active
		#ghost_mesh.visible = is_active
		if is_active:
			print(name + " is active")
		else:
			print(name + " is inactive")

## The player's 'jersey' color. #TODO move this to a Team class or team_attributes resource
@export var team_color: Color = Color.DARK_RED:
	set(value):
		var team_color_material:= StandardMaterial3D.new()
		team_color_material.albedo_color = value
		player_mesh.material_overlay = team_color_material

## The camera capturing the scene.
var scene_camera: Camera3D

## The sprite that indicates whether it's this player's turn.
@onready var active_sprite: Sprite3D = %ActiveSprite

## The sprite that indicates whether the player has the ball.
@onready var has_ball_sprite: Sprite3D = %HasBallSprite

## The label indicating the player's name.
@onready var name_label: Label3D = %NameLabel

## The mesh representing the player in 3D space.
@onready var player_mesh: CSGCombiner3D = %PlayerMesh

## The Player's [NavigationAgent3D], used for pathfinding
@onready var player_nav: NavigationAgent3D = %PlayerNav

## The Player's 'ghost', used for indicating potential movement
@onready var ghost_mesh: MeshInstance3D = %GhostMesh

# OVERRIDES

func _ready() -> void:
	name_label.text = name
	player_nav.connect("path_changed", _on_path_changed)

# CORE

# RECEIVERS
## Receive the signal from the [Court]
func on_movement_target_moved(target_position: Vector3):
	player_nav.target_position = target_position
	print_debug(player_nav.distance_to_target())

func _on_path_changed() -> void:
	print_debug("PlayerNav path has changed")

# SETTERS/GETTERS

# PRIVATE/HELPER
