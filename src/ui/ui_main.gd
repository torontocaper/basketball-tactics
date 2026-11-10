class_name UIMain
extends Control

#region Properties
@onready var ui_user_north: UIUser = $UIUserNorth
@onready var ui_user_south: UIUser = $UIUserSouth
#endregion

#region Methods
func _ready():
	ui_user_north.user_team = GameManager.current_game.away_team
	ui_user_south.user_team = GameManager.current_game.home_team
#endregion
