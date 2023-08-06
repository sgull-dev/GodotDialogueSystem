extends Node3D


var dialogue = []

@onready var text_box = $"../DialogueUI/DialogueLabel"
@onready var choice_box = $"../DialogueUI/ChoiceLabel"
@onready var name_box = $"../DialogueUI/NameLabel"
@onready var dialogue_manager = $"../DialogueManager"
@onready var choice = $"../ChoiceSystem"


@onready var camera_1 = $Camera1
@onready var camera_2 = $Camera2

var dialogue_playing := false
var line_typing := false
var index : int = 0

var choice_in_process := false
var choice_on_next_line := false
var choice_name : String


func start(path):
	index = 0
	if FileAccess.file_exists(path):
		dialogue = load_dialogue(path)
		
		typewrite(dialogue[index]['text'])
		text_box.visible = true
		name_box.text = dialogue[index]["name"]
		name_box.visible = true
		
		dialogue_playing = true
		choice_on_next_line = false
		choice_in_process = false
		
		switch_camera()
		
		if "choice" in dialogue[index]:
			choice_on_next_line = true
			choice_name = dialogue[index].choice
		
	else:
		stop()

func load_dialogue(path):
	var json_as_text = FileAccess.get_file_as_string(path)
	
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		#print(json_as_dict)
		return json_as_dict

func advance_dialogue():
	index += 1
	#check if last line of dialogue:
	if index < dialogue.size():
		#text_box.text = dialogue[index]['text']
		typewrite(dialogue[index]['text'])
		name_box.text = dialogue[index]['name']
		switch_camera()
		if "choice" in dialogue[index]:
			choice_on_next_line = true
			choice_name = dialogue[index].choice
			
	else:
		stop()

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
			$Timer.start(Settings.typing_speed)
			await $Timer.timeout
			i += 1
		else:
			text_box.text = line
			i+= 1000
	line_typing = false
	
func stop():
	#put camera back to normal
	clear_cameras()
	GameData.get_current_stage().get_node("player/Camera3D/Camera3D").make_current()
	#stop dialogue playing
	dialogue_playing = false
	#toggle hud not visible
	text_box.visible = false
	name_box.visible = false
	choice_box.visible = false
	#stop the dialogue in manager
	dialogue_manager.stop_dialogue()

func _process(_delta):
	if !choice_in_process:
		if line_typing and Input.is_action_just_pressed("ui_accept"):
			line_typing = false
		elif dialogue_playing and Input.is_action_just_pressed("ui_accept"):
			if choice_on_next_line:
				switch_to_choice()
			else:
				advance_dialogue()

func clear_cameras():
	#clear player camera
	GameData.get_current_stage().get_node("player/Camera3D/Camera3D").clear_current(false)
	#clear dialogue cameras
	var i = 1
	while i < get_child_count():
		var c = "Camera" + str(i)
		get_node(c).clear_current(false)
		i += 1

func switch_camera():
	var cam_index = int(dialogue[index]['cam'])
	if cam_index == 0:
		clear_cameras()
		GameData.get_current_stage().get_node("player/Camera3D/Camera3D").make_current()
	else:
		clear_cameras()
		var c = "Camera" + str(cam_index)
		get_node(c).make_current()
	#change camera based on data in dictionary
#	match dialogue[index]['cam']:
#		"0":
#			#print_debug("Switched to camera 0")
#			GameData.get_current_stage().get_node("player/Camera3D/Camera3D").make_current()
#			camera_1.clear_current(false)
#			camera_2.clear_current(false)
#		"1":
#			#print_debug("Switched to camera 1")
#			camera_1.make_current()
#			camera_2.clear_current(false)
#			GameData.get_current_stage().get_node("player/Camera3D/Camera3D").clear_current(false)
#		"2":
#			#print_debug("Switched to camera 2")
#			camera_2.make_current()
#			camera_1.clear_current(false)
#			GameData.get_current_stage().get_node("player/Camera3D/Camera3D").clear_current(false)
#		_:
#			print_debug("Error, cam data not found")
#			GameData.get_current_stage().get_node("player/Camera3D/Camera3D").make_current()
#			camera_1.clear_current(false)
#			camera_2.clear_current(false)

func switch_to_choice():
	choice.load_choice(choice_name)
	choice_on_next_line = false
	choice_name = ""
