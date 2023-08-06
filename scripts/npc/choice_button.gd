extends Button

@onready var dialogue_database := $"../../../DialogueDatabase"
@onready var choice = $"../../../ChoiceSystem"
var string_index_to_send := ""

func init(desc, data):
	text = desc
	string_index_to_send = data
	scale_hud()

func send_data():
	choice.close_menu()
	dialogue_database.receive_choice(string_index_to_send)


func _on_button_down():
	send_data()

func scale_hud():
	match Settings.hud_scale:
		1:
			add_theme_font_size_override("font_size", 13)
		2:
			add_theme_font_size_override("font_size", 16)
		3:
			add_theme_font_size_override("font_size", 20)
