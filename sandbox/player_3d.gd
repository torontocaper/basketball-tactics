class_name Player3D
extends CharacterBody3D

signal turn_finished(player: Player3D)

@export var player_name: String
@export var speed: float = 5.0

var is_active_player: bool: set = set_active
var min_max_range: float = 5.0
var destination: Vector3: set = set_destination

@onready var player_label: Label3D = $PlayerLabel
@onready var player_nav_agent: NavigationAgent3D = $PlayerNavAgent

func _ready() -> void:
	is_active_player = false
	player_label.text = player_name

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print_debug("%s has attempted to finish their turn" % player_name)
		turn_finished.emit(self)
		#if is_active_player:
			#print_debug("%s has actually ended their turn" % player_name)
		##player_nav_agent.target_position = Vector3(randf_range(-min_max_range, min_max_range), 0.0, randf_range(-min_max_range, min_max_range))
		#print_debug("Player will navigate to %s" % player_nav_agent.target_position)

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
	player_nav_agent.target_position = destination
