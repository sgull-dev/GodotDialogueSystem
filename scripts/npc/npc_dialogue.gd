extends Node3D

var dialogue_playing := false

var can_interact := false

@onready var dialogue_database = $"../DialogueDatabase"
@onready var dialogue_player = $"../DialoguePlayer"

signal dialogue_ended


func _process(_delta):
	if can_interact and !dialogue_playing and Input.is_action_just_pressed("interact"):
		
		play_dialogue()
	#debug purpose way to stop dialogue, this should be moved to dialogueplayer
#	if dialogue_playing and Input.is_action_just_pressed("ui_accept"):
#		stop_dialogue()

func play_dialogue():
	#change game state
	dialogue_playing = true
	GameData.change_game_state(GameData.GAME_STATE.DIALOGUE)
	#get correct dialogue from the database
	var dialogue = dialogue_database.pick_dialogue()
	#feed dialogue to the dialogue player
	dialogue_player.start(dialogue)
	#print_debug("Playing Dialogue.")

func stop_dialogue():
	if dialogue_playing:
		#change game state
		GameData.change_game_state(GameData.GAME_STATE.PLAY)
		dialogue_playing = false
		#send signal
		emit_signal("dialogue_ended")
	else:
		pass

func _on_interact_area_body_entered(body):
	if "is_player" in body:
		can_interact = true

func _on_interact_area_body_exited(body):
	if "is_player" in body:
		can_interact = false
