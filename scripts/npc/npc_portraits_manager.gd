extends Node3D

enum PORTRAIT_MODE {NORMAL, DIMMED, APPEARING}

#variables for changing effect behaviour
@export var appear_speed : float = 1.5
@export var appear_offset : float = 75.0
@export var dim_amount : float = 0.5
@export var dim_frame_length : float = 30

var slot_modes = [PORTRAIT_MODE.NORMAL,PORTRAIT_MODE.NORMAL,PORTRAIT_MODE.NORMAL]

@onready var slots = [$"../UI/Portraits/SlotLeft", $"../UI/Portraits/SlotMiddle", $"../UI/Portraits/SlotRight"]
@onready var bg_slot = $"../UI/Background"
@onready var dialogue_manager = $"../DialogueManager"

func _ready():
	reset_portrait_slots()
	dialogue_manager.dialogue_started.connect(reset_portrait_slots)

func reset_portrait_slots():
	#clear portraits and any effects
	var i = 0
	while i < slots.size():
		slots[i].texture = null
		slots[i].modulate = Color(1,1,1,1)
		#slots[i].get_node("AnimationPlayer").play("RESET")
		slot_modes[i] = PORTRAIT_MODE.NORMAL
		i += 1
	#clear background
	bg_slot.texture = null

func set_background(texture_path = null):
	if texture_path != null:
		var texture_to_set = load(texture_path)
		bg_slot.texture = texture_to_set
	else:
		bg_slot.texture = null

func set_portrait_to_slot(slot_index:int, texture_path):
	#load texture
	var texture_to_set = load(texture_path)
	#set texture to portrait slot
	slots[slot_index].texture = texture_to_set

func clear_portrait(slot_index:int):
	slots[slot_index].texture = null

func play_effect(slot_index:int, effect:String):
	match effect:
		"effect_dim":
			dim_portrait(slot_index)
		"effect_lighten":
			lighten_portrait(slot_index)
		"effect_appear_from_right":
			appear_from_right(slot_index)
		"effect_appear_from_left":
			appear_from_left(slot_index)
		"effect_rise_up":
			rise_up(slot_index)
		"effect_go_down":
			go_down(slot_index)
		_:
			print("Error: Unexpected Portrait Effect Type: " + effect)

func play_background_effect(effect:String):
	match effect:
		"effect_flash":
			bg_effect_flash()
		_:
			print("Error: Unexpected Background Effect Type: " + effect)
	#EFFECTS

func dim_portrait(slot):
	#don't do anyhting if lsot is already dimmed
	if slot_modes[slot] == PORTRAIT_MODE.DIMMED:
		return
	else:
		#print("Dimming Portrait "+str(slot))
		slot_modes[slot] = PORTRAIT_MODE.DIMMED
		var mod_color = Color(1,1,1,1)
		while mod_color.r > dim_amount:
			#cease if mode changes
			if !slot_modes[slot] == PORTRAIT_MODE.DIMMED:
				break
			#change modulate color
			slots[slot].modulate = mod_color
			mod_color.r -= dim_amount/dim_frame_length
			mod_color.g -= dim_amount/dim_frame_length
			mod_color.b -= dim_amount/dim_frame_length
			#loop
			await get_tree().physics_frame

func lighten_portrait(slot):
	#don't do anyhting if lsot is already normal
	if slot_modes[slot] == PORTRAIT_MODE.NORMAL:
		return
	else:
		#print("Lightening Portrait "+str(slot))
		slot_modes[slot] = PORTRAIT_MODE.NORMAL
		var mod_color = Color(dim_amount,dim_amount,dim_amount,1)
		while mod_color.r < 1.0:
			#cease if mode changes
			if !slot_modes[slot] == PORTRAIT_MODE.NORMAL:
				break
			#change modulate color
			slots[slot].modulate = mod_color
			mod_color.r += dim_amount/dim_frame_length
			mod_color.g += dim_amount/dim_frame_length
			mod_color.b += dim_amount/dim_frame_length
			await get_tree().physics_frame

func appear_from_right(slot):
	slot_modes[slot] = PORTRAIT_MODE.APPEARING
	var orig_x_pos = slots[slot].position.x
	var offset = appear_offset
	var mod_color = Color(dim_amount,dim_amount,dim_amount,1)
	
	var appear_interrupted = false
	while offset > 0:
		#cease if mode changes
		if !slot_modes[slot] == PORTRAIT_MODE.APPEARING:
			slots[slot].position.x = orig_x_pos
			slots[slot].modulate = Color(1,1,1,1)
			appear_interrupted = true
			break
		#set vars to slot
		slots[slot].position.x = orig_x_pos + offset
		slots[slot].modulate = mod_color
		#loop values
		offset -= 2
		mod_color.r += (1-dim_amount)/(appear_offset/appear_speed)
		mod_color.g += (1-dim_amount)/(appear_offset/appear_speed)
		mod_color.b += (1-dim_amount)/(appear_offset/appear_speed)
		await get_tree().physics_frame
	
	if !appear_interrupted:
		slot_modes[slot] = PORTRAIT_MODE.NORMAL

func appear_from_left(slot):
	print("Playing Portrait Effect Appear From Left in slot: "+str(slot))
	slot_modes[slot] = PORTRAIT_MODE.APPEARING
	var orig_x_pos = slots[slot].position.x
	var offset = -appear_offset
	var mod_color = Color(dim_amount,dim_amount,dim_amount,1)
	
	var appear_interrupted = false
	while offset < 0:
		#cease if mode changes
		if !slot_modes[slot] == PORTRAIT_MODE.APPEARING:
			slots[slot].position.x = orig_x_pos
			slots[slot].modulate = Color(1,1,1,1)
			appear_interrupted = true
			break
		#set vars to slot
		slots[slot].position.x = orig_x_pos + offset
		slots[slot].modulate = mod_color
		#loop values
		offset += appear_speed
		mod_color.r += (1-dim_amount)/(appear_offset/appear_speed)
		mod_color.g += (1-dim_amount)/(appear_offset/appear_speed)
		mod_color.b += (1-dim_amount)/(appear_offset/appear_speed)
		await get_tree().physics_frame
	
	if !appear_interrupted:
		slot_modes[slot] = PORTRAIT_MODE.NORMAL

func rise_up(slot):
	slots[slot].get_node("AnimationPlayer").play("RiseUp")

func go_down(slot):
	slots[slot].get_node("AnimationPlayer").play("GoDown")

func bg_effect_flash():
	$"../UI/FlashColor".visible = true
	$"../UI/FlashColor/AnimationPlayer".play("FlashBlack")
	await $"../UI/FlashColor/AnimationPlayer".animation_finished
	$"../UI/FlashColor".visible = false
