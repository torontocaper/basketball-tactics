class_name Hoop3D
extends Node3D

var ball_within_top_target: bool = false
var ball_within_bottom_target: bool = false
var target_entered_first: Area3D

@onready var top_target: Area3D = %TopTarget
@onready var bottom_target: Area3D = %BottomTarget

func _on_top_target_body_entered(body: Node3D) -> void:
	print("body %s entered top target" % body)
	if body is Ball3D:
		ball_within_top_target = true
	if ball_within_bottom_target == false:
		target_entered_first = top_target

func _on_bottom_target_body_entered(body: Node3D) -> void:
	print("body %s entered bottom target" % body)
	if body is Ball3D:
		ball_within_bottom_target = true
	if ball_within_top_target == false:
		target_entered_first = bottom_target

func _on_top_target_body_exited(body: Node3D) -> void:
	print("body %s exited top target" % body)
	if body is Ball3D:
		ball_within_top_target = false
	if target_entered_first == top_target and ball_within_bottom_target == false:
		print_debug("That's a miss off the rim!")

func _on_bottom_target_body_exited(body: Node3D) -> void:
	print("body %s exited bottom target" % body)
	if body is Ball3D:
		ball_within_bottom_target = false
	if target_entered_first == top_target:
		print_debug("That's a hoop!")
