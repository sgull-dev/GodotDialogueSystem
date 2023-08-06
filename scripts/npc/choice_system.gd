extends Node3D

@onready var ui = $"../ChoiceUI"
@onready var player = $"../DialoguePlayer"

var _choice_button = preload("res://scenes/ui/choice_button.tscn")
var choice_index : int

func _ready():
	ui.visible = false

func load_choice(choice_name):
	#get correct choice from database
	var i = 0
	while i < ChoiceDatabase.choices.size():
		if ChoiceDatabase.choices[i].choice_name == choice_name:
			choice_index = i
			i += 1000
		else:
			i += 1
	#clear old buttons
	i = 0 
	while i < ui.get_node("ChoiceButtons").get_child_count():
		ui.get_node("ChoiceButtons").get_child(i).queue_free()
		i += 1
	#assign the buttons to work with choice
	i = 1
	var assigning = true
	while assigning:
		var name_string = "choice_" + str(i)
		if name_string in ChoiceDatabase.choices[choice_index]:
			var button = _choice_button.instantiate()
			ui.get_node("ChoiceButtons").add_child(button)
			var signal_name = name_string + "_signal"
			button.init(ChoiceDatabase.choices[choice_index][name_string], ChoiceDatabase.choices[choice_index][signal_name])
		else:
			assigning = false
		i += 1
	#handle visiblity and info to other nodes and mouse 
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.visible = true
	player.choice_in_process = true

func close_menu():
	ui.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
