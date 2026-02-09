class_name Player3D
extends CharacterBody3D

signal turn_finished(player: Player3D)

## Player attributes and stats #TODO make these into a resource
@export var player_name: String
@export_range(0.0, 99.0, 1.0, "prefer_slider") var player_number: int
@export var speed: float = 5.0
#@export var attachment: Node

#var attachment_path: NodePath
# Ball variables
var game_ball: Ball3D: set = set_game_ball
var ball_position: Vector3
var ball_direction: Vector3
var ball_distance: float
var ball_coords: Vector3
var ball_path: NodePath

## Target Hoop variables
var target_hoop: Hoop3D: set = set_target_hoop
var hoop_position: Vector3
var hoop_direction: Vector3
var hoop_distance: float
var hoop_coords: Vector3

var can_grab_ball: bool = false
var has_ball: bool = false
var is_active_player: bool: set = set_active
var destination: Vector3: set = set_destination

@onready var player_hands: RemoteTransform3D = $PlayerHands
#@onready var hands: Marker3D = $Hands
@onready var number_label: Label3D = $NumberLabel
@onready var player_label: Label3D = $PlayerLabel
@onready var player_nav_agent: NavigationAgent3D = $PlayerNavAgent

func _ready() -> void:
	#if attachment:
		#attachment_path = player_hands.get_path_to(attachment)
	is_active_player = false
	player_label.text = player_name
	number_label.text = str(player_number)

func _unhandled_input(event: InputEvent) -> void:
	if is_active_player and event.is_action_pressed("end_turn"):
		print_debug("%s has attempted to finish their turn" % player_name)
		turn_finished.emit(self)
	
	if has_ball and event.is_action_pressed("shoot"):
		shoot()
	
	if event.is_action_pressed("grab"):
		if can_grab_ball:
			grab_ball()
		else:
			print_debug("%s can't reach the ball" % player_name)
	


func _physics_process(_delta: float) -> void:
	update_hoop_angles()
	if has_ball:
		look_at(hoop_coords)
	else:
		update_ball_angles()
		look_at(ball_coords)

	var intended_velocity = position.direction_to(player_nav_agent.get_next_path_position()) * speed
	player_nav_agent.set_velocity(intended_velocity)

## -- SETTERS --

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
	player_nav_agent.target_position = destination

func set_game_ball(ball: Ball3D) -> void:
	game_ball = ball
	print_debug("%s knows which ball is the game ball" % player_name)
	ball_path = player_hands.get_path_to(game_ball)

func set_has_ball(can_has_ball: bool) -> void:
	has_ball = can_has_ball
	if has_ball:
		print_debug("%s has the ball" % player_name)
	else:
		print_debug("%s no longer has the ball" % player_name)

func set_target_hoop(hoop: Hoop3D) -> void:
	target_hoop = hoop
	print_debug("%s knows which hoop is the target hoop" % player_name)
	hoop_position = target_hoop.global_position
	print_debug("hoop positioned at %s" % hoop_position)
	hoop_coords = Vector3(hoop_position.x, 1.0, hoop_position.z)
	print_debug("so its eye-level coords are %s" % hoop_coords)

## -- UPDATES --

func update_ball_angles() -> void:
	ball_position = game_ball.global_position
	ball_coords = Vector3(ball_position.x, 1.0, ball_position.z)
	ball_direction = global_position.direction_to(ball_position)
	ball_distance = global_position.distance_to(ball_position)

func update_hoop_angles() -> void:
	hoop_direction = global_position.direction_to(hoop_position)
	hoop_distance = global_position.distance_to(hoop_position)

## -- ACTIONS -- ##

#func attach() -> void:
	#player_hands.remote_path = attachment_path
	#print_debug("%s is attached to %s" % [player_name, attachment.name])

func grab_ball() -> void:
	print_debug("%s grabbed the ball" % player_name)
	has_ball = true
	#game_ball.reparent(self)
	game_ball.freeze = true
	#game_ball.global_position = player_hands.global_position
	player_hands.remote_path = ball_path

func shoot() -> void:
	player_hands.remote_path = ""
	var shot_direction = Vector3(hoop_direction.x, 0.6, hoop_direction.z)
	print_debug("%s will attempt a shot in the following direction: %s" % [player_name, shot_direction])
	game_ball.freeze = false
	game_ball.apply_impulse((shot_direction * hoop_distance), Vector3.DOWN * 0.1)
	has_ball = false

## -- RECEIVED SIGNALS --

func _on_player_nav_agent_target_reached() -> void:
	print_debug("made it to the target!\ndestination: %s\nglobal position = %s\nposition = %s" % [destination, global_position, position])
	print_debug("the direction from %s to the hoop is now %s and the distance is %s" % [player_name, hoop_direction, hoop_distance])

func _on_player_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_player_reach_body_entered(body: Node3D) -> void:
	if body is Ball3D and has_ball == false:
		print_debug("%s can grab the ball" % player_name)
		can_grab_ball = true

func _on_player_reach_body_exited(body: Node3D) -> void:
	if body is Ball3D:
		if has_ball == true:
			print_debug("%s has lost the ball" % player_name)
			#has_ball = false
		else:
			print_debug("%s can no longer grab the ball" % player_name)
		can_grab_ball = false
