extends Node3D

signal dialogue_ended

var can_interact := false
var dialogue_playing := false

@onready var dialogue_picker = $"../DialoguePicker"
@onready var dialogue_player = $"../DialoguePlayer"

func _process(_delta):
	#handle interacting with NPC/starting the dialogue
	if can_interact:
		if !dialogue_playing and Input.is_action_just_pressed("interact"):
			play_dialogue()

#start dialogue
func play_dialogue():
	#change game state
	dialogue_playing = true
	GameData.game_state = GameData.GAME_STATE.DIALOGUE
	#get correct dialogue from the database
	var dialogue = dialogue_picker.pick_dialogue()
	#feed dialogue to the dialogue player
	dialogue_player.start(dialogue)
	#print_debug("Playing Dialogue.")

#stop the dialogue
func stop_dialogue():
	if dialogue_playing:
		#change game state
		GameData.game_state = GameData.GAME_STATE.PLAY
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
