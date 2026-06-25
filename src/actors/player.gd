@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
enum State {PLANNING, MOVING}
#const

@export var player_speed: float = 10.0

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
		current_state = State.PLANNING
		#movement_line.visible = is_active
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

var current_state : State = State.PLANNING
	#set(value):
		#current_state = value
		#if current_state == State.MOVING:
			#

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

## The line to preview the movement path
#@onready var movement_line: MovementLine = %MovementLine

# OVERRIDES
func _ready() -> void:
	_connect_signals()
	name_label.text = name
	#player_nav.connect("path_changed", _on_path_changed)

func _physics_process(_delta: float) -> void:
	if current_state == State.PLANNING:
		if player_nav.target_position:
			player_nav.get_next_path_position()
	if current_state == State.MOVING:
		var next_movement_position: Vector3 = player_nav.get_next_path_position()
		var desired_velocity: Vector3 = global_position.direction_to(next_movement_position) * player_speed
		player_nav.velocity = desired_velocity
		#var current_path := player_nav.get_current_navigation_path()
		#movement_line.build_path_mesh(current_path)

# CORE

# RECEIVERS
## Receive the signal from the [Court]
func on_movement_target_moved(target_position: Vector3):
	if current_state == State.PLANNING:
		player_nav.target_position = target_position

func on_movement_target_set(target_position: Vector3):
	current_state = State.MOVING
	player_nav.target_position = target_position

func on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
	#print_debug("Safe velocity computed: %s" % safe_velocity)

#func _on_path_changed() -> void:
	#print_debug("PlayerNav path has changed")

# SETTERS/GETTERS

# PRIVATE/HELPER
func _connect_signals() -> void:
	player_nav.connect("velocity_computed", on_velocity_computed)
