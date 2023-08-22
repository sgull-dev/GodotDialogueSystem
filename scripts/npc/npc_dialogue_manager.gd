extends Node3D

signal dialogue_started
signal dialogue_ended

var can_interact := false
var dialogue_playing := false

@onready var dialogue_picker = $"../DialoguePicker"
@onready var dialogue_player = $"../DialoguePlayer"


func _input(event):
	if event.is_action_pressed("interact"):
		#print("Pressed Action Key Interact.")
		if can_interact:
			#print("Player is in field of NPC interaction.")
			if !dialogue_playing:
				#print("NPC Dialogue is not playing, starting dialogue...")
				play_dialogue()

#start dialogue
func play_dialogue():
	print("Starting dialogue.")
	#change game state
	dialogue_started.emit()
	dialogue_playing = true
	GameData.change_game_state(GameData.GAME_STATE.DIALOGUE)
	#get correct dialogue from the database
	var dialogue = dialogue_picker.pick_dialogue()
	#feed dialogue to the dialogue player
	dialogue_player.start(dialogue)

#stop the dialogue
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
		print("Player is in interact area, enabling interaction.")
		can_interact = true

func _on_interact_area_body_exited(body):
	if "is_player" in body:
		can_interact = false
