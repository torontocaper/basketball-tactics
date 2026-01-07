#@tool
#@icon
class_name TurnManager
extends Node
## Documentation comments

## Signals
## Enums
## Constants
## @export variables
## Regular variables
var turn_number: int = 0
var turn_order: Array[Player] = []
## @onready variables

## Overridden built-in virtual methods
#func _init() -> void:
#func _enter_tree() -> void:
func _ready() -> void:
	print_debug("Turn Manager ready")
#func _process(delta: float) -> void:
#func _physics_process(delta: float) -> void:
## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func set_turn_order(players: Array[Player]) -> Array[Player]:
	print_debug("Setting the turn order for this possession/period/game")
	for player in players:
		var player_dice_roll: int = randi_range(1, 20)
		print_debug("Player %s rolled a %s" % [player.name, player_dice_roll])
		var player_initiative_score: int = player_dice_roll + player.attributes.reflexes
		print_debug("With their reflexes score of %s, that gives them an initiative score of %s" % [player.attributes.reflexes, player_initiative_score])
	return turn_order
## Subclasses
