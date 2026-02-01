extends CharacterBody3D

@export var player_name: String

var min_max_range: float = 5.0

@onready var player_label: Label3D = $PlayerLabel
@onready var player_nav_agent: NavigationAgent3D = $PlayerNavAgent

func _ready() -> void:
	player_label.text = player_name

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		player_nav_agent.target_position = Vector3(randf_range(-min_max_range, min_max_range), 0.0, randf_range(-min_max_range, min_max_range))
		print_debug("Player will navigate to %s" % player_nav_agent.target_position)

func _physics_process(_delta: float) -> void:
	var intended_velocity = position.direction_to(player_nav_agent.get_next_path_position())
	player_nav_agent.set_velocity(intended_velocity)
	move_and_slide()


func _on_player_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
