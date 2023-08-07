extends Button

@onready var dialogue_picker := $"../../../DialoguePicker"
@onready var choice = $"../../../ChoiceManager"

#store info to send to dialogue_picker
var string_identifier_to_send := ""

#initialize button
func init(choice_description: String, data: String):
	text = choice_description
	string_identifier_to_send = data

#pick choice
func send_data():
	choice.close_menu()
	dialogue_picker.receive_choice(string_identifier_to_send)


func _on_button_down():
	send_data()
