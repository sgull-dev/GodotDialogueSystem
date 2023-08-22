extends Node3D

#store current dialogue here as data
var dialogue = []
#index to keep track of current line
var index : int = 0
#variables to keep track of dialogue state
var dialogue_playing := false
var line_typing := false
#variables to keep track of choice state
var choice_in_process := false
var choice_on_next_line := false
#what choice is currently enabled
var choice_name : String

@onready var ui = $"../UI"
@onready var text_panel = $"../UI/DialoguePanel"
@onready var text_box = $"../UI/DialogueContainer/DialogueLabel"
@onready var name_box = $"../UI/DialogueContainer/NameLabel"
@onready var dialogue_manager = $"../DialogueManager"
@onready var choice_manager = $"../ChoiceManager"
@onready var portrait_manager = $"../PortraitsManager"

#handle receiving inputs and dealing with them based on current dialogue state
func _process(_delta):
	#don't allow advancing dialogue, if choice in progress
	if !choice_in_process:
		#skip to the end of the typewrite effect on input, if line is typing
		if line_typing and Input.is_action_just_pressed("ui_accept"):
			line_typing = false
		#if line has been typed, then move to next line
		elif dialogue_playing and Input.is_action_just_pressed("ui_accept"):
			#if next line is choice, begin choice
			if choice_on_next_line:
				switch_to_choice()
			#else move to next line
			else:
				advance_dialogue()

#start dialogue
func start(path):
	#text_box.grab_focus()
	#reset line index
	index = 0
	#check if dialogue exists at path
	if FileAccess.file_exists(path):
		#if it exists, we load the file
		dialogue = load_dialogue(path)
		#start typewrting first line with correct name
		typewrite(dialogue[index]['text'])
		name_box.text = dialogue[index]["name"]
		#handle portraits
		handle_portraits()
		#toggle UI visible
		ui.visible = true
		#set state vars
		dialogue_playing = true
		choice_on_next_line = false
		choice_in_process = false
		
		#check if there is a choice on current line
		if "choice" in dialogue[index]:
			#if there is enable choice firing on next input and set choice to be correct
			choice_on_next_line = true
			choice_name = dialogue[index].choice
	#if file doesn't exist, don't start dialogue
	else:
		stop()

#load dialogue from file to data
func load_dialogue(path):
	var json_as_text = FileAccess.get_file_as_string(path)
	
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		#print(json_as_dict)
		return json_as_dict

#handle advancing dialogue from player input
func advance_dialogue():
	index += 1
	#check if last line of dialogue:
	if index < dialogue.size():
		#text_box.text = dialogue[index]['text']
		typewrite(dialogue[index]['text'])
		name_box.text = dialogue[index]['name']
		#handle portraits
		handle_portraits()
		
		if "choice" in dialogue[index]:
			choice_on_next_line = true
			choice_name = dialogue[index].choice
			
	else:
		stop()

#typewrite effect, display dialogue line one character at a time, waiting a delay
func typewrite(line):
	line_typing = true
	
	var display_line = ""
	var i = 0
	while i < line.length():
		#check if skip has been set
		if line_typing:
			#add a character to display line
			var b = line.unicode_at(i)
			display_line += String.chr(b)
			#set text
			text_box.text = display_line
			#wait a delay
			$Timer.start(Settings.typing_delay)
			await $Timer.timeout
			i += 1
		#if line has been skipped, show full line straight away
		else:
			text_box.text = line
			i+= 1000
	line_typing = false

#stop the dialogue
func stop():
	#stop dialogue playing
	dialogue_playing = false
	#toggle hud not visible
	ui.visible = false
	#stop the dialogue in manager
	dialogue_manager.stop_dialogue()

func switch_to_choice():
	choice_manager.load_choice(choice_name)
	choice_on_next_line = false
	choice_name = ""

func handle_portraits():
	#handle setting portrait textures
	if dialogue[index].has("portrait_right"):
		if dialogue[index]["portrait_right"] == "null":
			portrait_manager.clear_portrait(2)
		else:
			var texture_path = "res://assets/ui/portraits/" + dialogue[index]["portrait_right"] + ".png"
			portrait_manager.set_portrait_to_slot(2, texture_path)
		
	if dialogue[index].has("portrait_middle"):
		if dialogue[index]["portrait_middle"] == "null":
			portrait_manager.clear_portrait(1)
		else:
			var texture_path = "res://assets/ui/portraits/" + dialogue[index]["portrait_middle"] + ".png"
			portrait_manager.set_portrait_to_slot(1, texture_path)
	
	if dialogue[index].has("portrait_left"):
		if dialogue[index]["portrait_left"] == "null":
			portrait_manager.clear_portrait(0)
		else:
			var texture_path = "res://assets/ui/portraits/" + dialogue[index]["portrait_left"] + ".png"
			portrait_manager.set_portrait_to_slot(0, texture_path)
	#handle setting portrait effects
	if dialogue[index].has("portrait_right_effect"):
		portrait_manager.play_effect(2, dialogue[index]["portrait_right_effect"])
	if dialogue[index].has("portrait_middle_effect"):
		portrait_manager.play_effect(1, dialogue[index]["portrait_middle_effect"])
	if dialogue[index].has("portrait_left_effect"):
		portrait_manager.play_effect(0, dialogue[index]["portrait_left_effect"])
	#handle setting background
	if dialogue[index].has("background"):
		if dialogue[index]["background"] == "null":
			portrait_manager.set_background()
		else:
			var texture_path = "res://assets/ui/backgrounds/" + dialogue[index]["background"] + ".png"
			portrait_manager.set_background(texture_path)
	if dialogue[index].has("background_effect"):
		portrait_manager.play_background_effect(dialogue[index]["background_effect"])
