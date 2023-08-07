extends Node3D

@export var stage_name : String
var is_stage := true

#initialize scene for playing
func _ready():
	GameData.game_state = GameData.GAME_STATE.PLAY
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
