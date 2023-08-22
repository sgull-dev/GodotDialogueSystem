extends Node3D

#preloaded choice button for adding choices
var _choice_button = preload("res://scenes/ui/choice_button.tscn")
var choice_index : int

@onready var ui = $"../UI/ChoiceContainer"
@onready var dialogue_player = $"../DialoguePlayer"

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
	while i < ui.get_child_count():
		ui.get_child(i).queue_free()
		i += 1
	#assign the buttons to work with choice
	i = 1
	var assigning = true
	while assigning:
		var name_string = "choice_" + str(i)
		if name_string in ChoiceDatabase.choices[choice_index]:
			var button = _choice_button.instantiate()
			ui.add_child(button)
			var signal_name = name_string + "_signal"
			button.init(ChoiceDatabase.choices[choice_index][name_string], ChoiceDatabase.choices[choice_index][signal_name])
		else:
			assigning = false
		i += 1
	#wait one frame so older choice buttons have been flushed away
	await get_tree().process_frame
	#handle visiblity and info to other nodes and mouse 
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.visible = true
	dialogue_player.choice_in_process = true
	ui.get_child(0).grab_focus()
	#assign focus neighbors to choice buttons
	if ui.get_child_count() > 1:
		ui.get_child(0).focus_neighbor_bottom = NodePath("../" + str(ui.get_child(1).name))
		var u = 1
		while u < ui.get_child_count()-1:
			ui.get_child(u).focus_neighbor_top = NodePath("../" + str(ui.get_child(u-1).name))
			ui.get_child(u).focus_neighbor_bottom = NodePath("../" + str(ui.get_child(u+1).name))
			u += 1
		ui.get_child(u).focus_neighbor_top = NodePath("../" + str(ui.get_child(u-1).name))
	

func close_menu():
	ui.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
