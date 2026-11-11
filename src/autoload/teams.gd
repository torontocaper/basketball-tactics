extends Node

const BLUE_TEAM = preload("uid://b567xj1sggro")
const GREEN_TEAM = preload("uid://wxpvy2t8ocp")
const RED_TEAM = preload("uid://d1f3fg44yrtfw")

var teams : Array[Team]

func _ready() -> void:
	teams = [
		BLUE_TEAM.instantiate(),
		GREEN_TEAM.instantiate(),
		RED_TEAM.instantiate()
	]
