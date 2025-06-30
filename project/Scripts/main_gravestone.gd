extends Node3D

@onready var empty_g = $empty_grave_slots
@onready var slot_1 = $grave_slot_1
@onready var slot_2 = $grave_slot_2
@onready var slot_3 = $grave_slot_3
@onready var slot_4 = $grave_slot_4
@onready var Shift1 : AudioStreamPlayer = $Shift1
@onready var Shift2 : AudioStreamPlayer = $Shift2
@onready var Shift3 : AudioStreamPlayer = $Shift3
@onready var Shift4 : AudioStreamPlayer = $Shift4

func _ready():
	Events.connect("play_gravestone_animation", animate)
	

func animate(msg:String):
	await get_tree().create_timer(1).timeout
	empty_g.visible = false
	slot_1.visible = true
	Shift1.play()
	
	await get_tree().create_timer(1).timeout
	slot_1.visible = false
	slot_2.visible = true
	Shift2.play()
	
	await get_tree().create_timer(1).timeout
	slot_2.visible = false
	slot_3.visible = true
	Shift3.play()
	
	await get_tree().create_timer(1).timeout
	slot_3.visible = false
	slot_4.visible = true
	Shift4.play()
