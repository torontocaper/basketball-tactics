extends Node3D

@export var game_ball: Ball3D
@export var main_hoop: Hoop3D

var players: Array[Player3D]
var active_player: Player3D

func _ready() -> void:
	for player in get_tree().get_nodes_in_group("players"):
		players.append(player)
		print_debug("Added %s to players array at index %s" % [player.player_name, players.find(player)])
		player.connect("turn_finished", on_player_turn_finished)
		player.set_game_ball(game_ball)
		player.set_target_hoop(main_hoop)
	active_player = players[0]
	print_debug("Making %s active" % active_player.player_name)
	active_player.is_active_player = true
		#if player != active_player:
			#print_debug("Making %s inactive" % player.player_name)
			#player.is_active_player = false
		#else:
			#player.is_active_player = true

func _on_court_floor_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print_debug("There's been an input event on the court at position %s" % event_position)
		active_player.destination = Vector3(event_position.x, 1.0, event_position.z)

func on_player_turn_finished(player: Player3D) -> void:
	print_debug("Turn over for %s" % player.player_name)
	player.is_active_player = false
	var finished_player_index = players.find(player)
	var next_player_index: int
	if finished_player_index < players.size() - 1:
		next_player_index = finished_player_index + 1
	else:
		next_player_index = 0
	var next_player = players[next_player_index]
	print_debug("Now it's %s's turn" % next_player.player_name)
	active_player = next_player
	next_player.is_active_player = true
	
	
