class_name Player3D
extends CharacterBody3D

signal turn_finished(player: Player3D)

const BALL_3D = preload("uid://dbtsdrruobqof")

@export var player_name: String
@export var speed: float = 5.0
@export var shot_boost: float = 1.0
@export var target_hoop: Hoop3D
@export var shot_angle: float = 70.0

var is_active_player: bool: set = set_active
var min_max_range: float = 5.0
var destination: Vector3: set = set_destination

@onready var hands: Marker3D = $Hands
@onready var player_label: Label3D = $PlayerLabel
@onready var player_nav_agent: NavigationAgent3D = $PlayerNavAgent

func _ready() -> void:
	is_active_player = false
	player_label.text = player_name

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print_debug("%s has attempted to finish their turn" % player_name)
		turn_finished.emit(self)
	
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(_delta: float) -> void:
	var intended_velocity = position.direction_to(player_nav_agent.get_next_path_position()) * speed
	player_nav_agent.set_velocity(intended_velocity)


func _on_player_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func set_active(is_active: bool) -> void:
	if is_active:
		print_debug("%s is now active" % player_name)
		player_label.uppercase = true
		set_process_unhandled_input(true)
		player_nav_agent.avoidance_priority = 1.0
	else:
		print_debug("%s is now inactive" % player_name)
		player_label.uppercase = false
		set_process_unhandled_input(false)
		player_nav_agent.avoidance_priority = 0.5

func set_destination(new_destination: Vector3) -> void:
	destination = new_destination
	print_debug("New destination set for %s: %s" % [player_name, destination])
	look_at(destination)
	player_nav_agent.target_position = destination

func shoot() -> void:
	var hoop_position = target_hoop.position
	var hoop_direction = position.direction_to(hoop_position)
	var shot_direction = hoop_direction.rotated(Vector3.RIGHT, deg_to_rad(shot_angle))
	look_at(Vector3(hoop_position.x, 1.0, hoop_position.z))
	print_debug("%s will attempt a shot in the following direction: %s" % [player_name, hoop_direction])
	var ball:= BALL_3D.instantiate()
	ball.position = hands.global_position
	get_tree().current_scene.add_child(ball)
	ball.apply_torque_impulse(Vector3.BACK)
	ball.apply_central_impulse(shot_direction * position.distance_to(hoop_position))
