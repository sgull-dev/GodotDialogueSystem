extends Node3D

@onready var player = $"../DialoguePlayer"
@onready var manager = $"../DialogueManager"

func pick_dialogue()-> String:
	manager.dialogue_ended.connect(go_to_captive_stage)
	return "res://assets/dialogue/pirate_recruiter_1.json"
	

func receive_choice(string):
	match string:
		"no":
			player.start("res://assets/dialogue/pirate_recruiter_2.json")
		"join":
			player.start("res://assets/dialogue/pirate_recruiter_3.json")

func go_to_captive_stage():
	#load the pirate cove stage on dialogue end
	StageLoader.load_stage(GameData.stages.stage_pirate_ship)
