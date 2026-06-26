#@tool
#@icon(icon_path: String)
class_name Player
extends CharacterBody3D
## Base class for on-court actors

#signal
enum State {
	INACTIVE,
	ACTIVE,
	MOVING
	}
#const

@export var current_state : State = State.INACTIVE:
	set(value):
		if not is_node_ready():
			await ready
		current_state = value
		match current_state:
			State.INACTIVE:
				active_sprite.visible = false
				player_nav.debug_enabled = false
				if _are_signals_connected:
					_disconnect_signals()
			State.ACTIVE:
				active_sprite.visible = true
				player_nav.debug_enabled = true
				if not _are_signals_connected:
					_connect_signals()
			State.MOVING:
				pass

@export var player_speed: float = 10.0

## The player's 'jersey' color. #TODO move this to a Team class or team_attributes resource
@export var team_color: Color = Color.DARK_RED:
	set(value):
		var team_color_material:= StandardMaterial3D.new()
		team_color_material.albedo_color = value
		player_mesh.material_overlay = team_color_material

var _are_signals_connected: bool = false

## The sprite that indicates whether it's this player's turn.
@onready var active_sprite: Sprite3D = %ActiveSprite

## The label indicating the player's name.
@onready var name_label: Label3D = %NameLabel

## The mesh representing the player in 3D space.
@onready var player_mesh: CSGCombiner3D = %PlayerMesh

## The Player's [NavigationAgent3D], used for pathfinding
@onready var player_nav: NavigationAgent3D = %PlayerNav

# OVERRIDES
func _ready() -> void:
	name_label.text = name

func _physics_process(_delta: float) -> void:
	if current_state == State.ACTIVE:
		if player_nav.target_position:
			player_nav.get_next_path_position()
	if current_state == State.MOVING:
		var next_movement_position: Vector3 = player_nav.get_next_path_position()
		var desired_velocity: Vector3 = global_position.direction_to(next_movement_position) * player_speed
		player_nav.velocity = desired_velocity


# CORE
func update_movement_target(target: Vector3) -> void:
	if current_state == State.ACTIVE:
		player_nav.target_position = target

func move_toward_target(target: Vector3) -> void:
	print_debug("%s headed for target of %s" % [name, player_nav.target_position])
	current_state = State.MOVING
	player_nav.target_position = target

# RECEIVERS

func _on_target_reached() -> void:
	print_debug("%s reached target of %s (actual position = %s)" % [name, player_nav.target_position, global_position])
	current_state = State.ACTIVE

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
	#print_debug("Safe velocity computed: %s" % safe_velocity)


# PRIVATE/HELPER
func _connect_signals() -> void:
	player_nav.connect("target_reached", _on_target_reached)
	player_nav.connect("velocity_computed", _on_velocity_computed)
	_are_signals_connected = true
#
func _disconnect_signals() -> void:
	player_nav.disconnect("velocity_computed", _on_velocity_computed)
	player_nav.disconnect("target_reached", _on_target_reached)
	_are_signals_connected = false
