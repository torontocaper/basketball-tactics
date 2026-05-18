#@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
#enum
#const

@export var has_ball: bool = false:
	set(h_b):
		has_ball_decal.visible = h_b

@export var is_active: bool = false: 
	set(i_a):
		active_decal.visible = i_a

@export var team_color: Color = Color.DARK_RED:
	set(t_c):
		var team_color_material:= StandardMaterial3D.new()
		team_color_material.albedo_color = t_c
		player_mesh.set_surface_override_material(0, team_color_material)

@onready var active_decal: Decal = %ActiveDecal
@onready var has_ball_decal: Decal = %HasBallDecal
@onready var name_label: Label3D = %NameLabel
@onready var player_mesh: MeshInstance3D = %PlayerMesh

# OVERRIDES

func _ready() -> void:
	name_label.text = name

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE

# RECEIVERS

# SETTERS/GETTERS (argument abbreviations allowed)

# PRIVATE/HELPER
