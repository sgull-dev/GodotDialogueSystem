extends Node3D

#Here is a sample script showing how a DialoguePicker (dialp_) script should look like
#two functions to assess incoming requests and feed correct dialogue paths to the system

@onready var player = $"../DialoguePlayer"

func pick_dialogue() -> String:
	return "res://assets/dialogue/test_1.json"

func receive_choice(string):
	match string:
		"yes":
			player.start("res://assets/dialogue/test_2.json")
		"no":
			player.start("res://assets/dialogue/test_3.json")
