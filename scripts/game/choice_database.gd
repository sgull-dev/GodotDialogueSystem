extends Node

#array of dictionaries containing info about Choices. each contains choice name, choices in it 
#and the signal to send from each choice that the dialogue pickers can latch to
var choices 

func _ready():
	setup_database()

#load choice database from file to data
func setup_database():
	var json_as_text = FileAccess.get_file_as_string("res://assets/dialogue/choice_database.json")
	
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		choices = json_as_dict
