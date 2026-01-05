#@tool
#@icon
#class_name
extends Node2D
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
## @onready variables
# Child Nodes
#@onready var player: Player = %Player1
@onready var navigation_manager: NavigationManager = %NavigationManager
@onready var court: TileMapLayer = %Court
@onready var debug_ui: DebugUI = %DebugUI
@onready var players: Node = %Players

func _ready() -> void:
	print_debug("Game Manager ready")
	# Get the players as variables
	for player_number in players.get_child_count():
		var player = players.get_child(player_number)
		player.position = court.map_to_local(Vector2i.ZERO + Vector2i.ONE * player_number)
		navigation_manager.connect("path_found", player.move_along_path) #TODO: hook this up by turn
	# Get the tile size and used rect from the TilemapLayer and send the info to NavigationManager
	var map_tile_size:= court.tile_set.tile_size
	var map_rect:= court.get_used_rect()
	navigation_manager.draw_astar_grid(map_tile_size, map_rect)
	# Move the player to cell with ID (0, 0)
	#player.position = court.map_to_local(Vector2i.ZERO)
	# Connect signals


func _unhandled_input(event: InputEvent) -> void:
	# Get the mouse position and, using the TileMapLayer for convenience, set the hovered_cell navigation variable
	if navigation_manager.astar_grid:
		navigation_manager.hovered_cell = court.local_to_map(get_local_mouse_position())
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
			# Get the mouse position and, using the TileMapLayer for convenience, set the hovered_cell navigation variable
			navigation_manager.clicked_cell = court.local_to_map(get_local_mouse_position())
