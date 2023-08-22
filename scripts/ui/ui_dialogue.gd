extends Control

@onready var dialogue_box = $DialogueContainer/DialogueLabel
@onready var name_box = $DialogueContainer/NameLabel
@onready var choice_ui = $ChoiceContainer
@onready var dialogue_panel = $DialoguePanel

func _ready():
#	dialogue_panel.visible = false
#	dialogue_box.visible = false
#	name_box.visible = false
#	choice_ui.visible = false
	visible = false
