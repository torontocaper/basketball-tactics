#@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
#enum
#const
@export var player_name: String = "PlayerName"
var is_active: bool = false: 
	set(i_a):
		active_decal.visible = i_a

#@onready var
@onready var name_label: Label3D = %NameLabel
@onready var active_decal: Decal = %ActiveDecal

# OVERRIDES

func _ready() -> void:
	name_label.text = player_name

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

# CORE


# RECEIVERS

# SETTERS/GETTERS (argument abbreviations allowed)

# PRIVATE/HELPER
