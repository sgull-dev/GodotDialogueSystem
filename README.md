# GodotDialogueSystem
 Dialogue System for Godot 4 utilizing JSON files as dialogues. This branch contains the system for portraits and bg.

Usage:
Place all the dialogue nodes under a NPC scene, and create a DialoguePicker code for the NPC. 
Write the dialouges to JSON and choices under choice_database. Then reference the paths to those dialouges in the dialogue_picker_npc_name code to create the unique dialogue tree for the NPC.

"portrait_left"
"portrait_left_effect"

Parameters for portrait slots. Can be used for left, middle and right slots. Set portrait value with "string_name" and the corresponding image to res://assets/ui/portraits. 
Possible effects:

"effect_appear_from_left"
"effect_appear_from_right"
"effect_dim"
"effect_lighten"
"effect_rise_up"
"effect_go_down"

Background can be set with

"background" 
"background_effect"

Bg Effects:
"effect_flash"
