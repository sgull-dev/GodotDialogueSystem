extends Node3D

@onready var dialogue_manager = $"../DialogueManager"
@onready var dialogue_player = $"../DialoguePlayer"

#houses two functions to feed correct dialogues to dialogue component
#seperate dialogue_picker code for each npc, giving unique dialogue trees

#return the path to the correct dialogue
func pick_dialogue()-> String:
	return "res://dialogue/test_1.json"

#receive info from choice, then do x
#with dialogue_player.start(), one can start a dialogue while still keeping the dialogue playing with manager
func receive_choice(identifier:String):
	match identifier:
		"yes":
			dialogue_player.start("res://dialogue/test_2.json")
		"no":
			dialogue_player.start("res://dialogue/test_3.json")
