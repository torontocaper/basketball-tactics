@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
#enum
#const
@export var ray_normal: Vector3
@export var ray_origin: Vector3
@export var ray_magnitude: float

## Whether the player is currently in possession of the ball.
@export var has_ball: bool = false:
	set(h_b):
		if not is_node_ready():
			await ready
		has_ball_sprite.visible = h_b

## Whether it's this player's turn.
@export var is_active: bool = false: 
	set(i_a):
		if not is_node_ready():
			await ready
		is_active = i_a
		active_sprite.visible = is_active
		movement_target_sprite.visible = is_active
		if is_active:
			print(name + " is active")
		else:
			print(name + " is inactive")

## The player's 'jersey' color. #TODO move this to a Team class or team_attributes resource
@export var team_color: Color = Color.DARK_RED:
	set(t_c):
		var team_color_material:= StandardMaterial3D.new()
		team_color_material.albedo_color = t_c
		player_mesh.set_surface_override_material(0, team_color_material)

## The camera capturing the scene.
var scene_camera: Camera3D

## The sprite that indicates whether it's this player's turn.
@onready var active_sprite: Sprite3D = %ActiveSprite

## The sprite that indicates whether the player has the ball.
@onready var has_ball_sprite: Sprite3D = %HasBallSprite

## The sprite that indicates where the mouse is pointing when the player is active and in the 'move-choosing' state.
@onready var movement_target_sprite: MeshInstance3D = %MovementTargetSprite

## The label indicating the player's name.
@onready var name_label: Label3D = %NameLabel

## The mesh representing the player in 3D space.
@onready var player_mesh: MeshInstance3D = %PlayerMesh

# OVERRIDES

func _ready() -> void:
	name_label.text = name

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if is_active:
		scene_camera = get_viewport().get_camera_3d()
		#TODO: figure this out
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		ray_normal = scene_camera.project_ray_normal(mouse_position)
		ray_origin = scene_camera.project_ray_origin(mouse_position)
		ray_magnitude = scene_camera.project_ray_origin(mouse_position).length()
		#print("Ray origin: %s" % ray_normal)
		#print("Ray normal: %s" % ray_normal)
		movement_target_sprite.global_position = scene_camera.project_position(get_viewport().get_mouse_position(), ray_magnitude)

# CORE

# RECEIVERS

# SETTERS/GETTERS (argument abbreviations allowed)

# PRIVATE/HELPER
