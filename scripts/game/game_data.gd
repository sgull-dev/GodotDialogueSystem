extends Node

signal game_state_changed(state)

enum GAME_STATE {PLAY, DIALOGUE, CUTSCENE, MENU}
var game_state = GAME_STATE.PLAY

#vars for player
var player_position : Vector3
var player_move_direction : Vector3
var cam_rotation : float

func change_game_state(state):
	if state == GAME_STATE.PLAY:
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		get_tree().paused = true
	game_state = state
	
	game_state_changed.emit(state)

#get reference to current stage
func get_current_stage() -> Variant:
	var current_scene = null
	var i = 0
	while i < get_tree().get_root().get_child_count():
		if "is_stage" in get_tree().get_root().get_child(i):
			current_scene = get_tree().get_root().get_child(i)
			i += 100
		i += 1
	return current_scene
