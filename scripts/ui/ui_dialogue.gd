extends Control

@onready var dialogue_box = $DialogueContainer/DialogueLabel
@onready var name_box = $DialogueContainer/NameLabel
@onready var choice_ui = $ChoiceContainer

func _ready():
	dialogue_box.visible = false
	name_box.visible = false
	choice_ui.visible = false
