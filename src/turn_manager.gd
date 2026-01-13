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

## Remaining virtual methods
## Overridden custom methods
## Remaining methods
func set_turn_order(players: Array[Player]) -> Array[Player]:
	print_debug("Setting the turn order for this possession/period/game")
	var initiative_order: Array[Array]
	for player in players:
		var player_reflexes = player.attributes.reflexes
		var player_dice_roll: int = Dice.roll(20)
		print_debug("Player %s rolled %s" % [player.name, player_dice_roll])
		var player_initiative_score: int = player_dice_roll + player_reflexes
		print_debug("With their reflexes score of %s, that gives them an initiative score of %s" % [player.attributes.reflexes, player_initiative_score])
		initiative_order.append([player, player_initiative_score])
	initiative_order.sort_custom(sort_ascending)
	for element in initiative_order:
		turn_order.append(element[0])
	print_debug("The turn order will be: %s" % str(turn_order))
	return turn_order


func sort_ascending(element_a, element_b) -> bool:
	if element_a[1] > element_b[1]:
		return true
	else:
		return false
