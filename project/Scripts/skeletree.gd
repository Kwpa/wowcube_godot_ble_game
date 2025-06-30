extends Sprite3D

@onready var skull = $skull
@onready var sounds : AudioStreamPlayer3D = $sounds
@onready var speech_label : Label = $SubViewport/Control/ColorRect/Label
@onready var control : Control = $SubViewport/Control
var tween : Tween

var state1 = false
var state2 = false
var state3 = false

var string0 = "Hey! You!"
var string1 = "Find the fragments hidden around"
var string2 = "Then place them in the tombstone"
var string3 = "Easy right?"
var string4 = "You got this, right?"

var string0B = "Good to see you again!"
var string1B = "The artifact you hold is special"
var string2B = "Twist it one way, and the moon moves"
var string3B = "Easier to see under a full moon!"
var string4B = "Keep going!"

var string0C = "I might have a hint, huhuh"
var string1C = "Use your power to tap into the world"
var string2C = "Triple tap your artifact"
var string3C = "It'll shake things up!"
var string4C = "Are you still here?"

var string0D = "The artifact... it knows..."
var string1D = "When you are close, it will glow"
var string2D = "Other goodies might be hiding too"
var string3D = "Find me again to learn more..."
var string4D = "Are you still here?"

@export var speaker_id = "skeletree1"

func _ready():
	Events.connect("animate_skeletree", animate)
	Events.connect("activate_speaker",speak_loop)
	Events.connect("activate_nearby_speaker",nearby_speaker)
	Events.connect("deactivate_speaker",deactivate_speaker)
	Events.connect("skeletree_state2",speaker_state)
	
	state1=true
	check_state()

func speaker_state(msg : String):
	if msg == "start":
		state1 = false
		state2 = true
		while state2:
			if speaker_id == "skeletree1":
				set_text(string1)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string2)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string3)
				control.visible = true
				await get_tree().create_timer(4).timeout
				control.visible = false
				await get_tree().create_timer(4).timeout
			elif speaker_id == "skeletree2":
				set_text(string1B)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string2B)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string3B)
				control.visible = true
				await get_tree().create_timer(4).timeout
				control.visible = false
				await get_tree().create_timer(4).timeout
			elif speaker_id == "skeletree3":
				set_text(string1C)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string2C)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string3C)
				control.visible = true
				await get_tree().create_timer(4).timeout
				control.visible = false
				await get_tree().create_timer(4).timeout
			elif speaker_id == "skeletree4":
				set_text(string1D)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string2D)
				control.visible = true
				await get_tree().create_timer(4).timeout
				set_text(string3D)
				control.visible = true
				await get_tree().create_timer(4).timeout
				control.visible = false
				await get_tree().create_timer(4).timeout
	if msg == "stop":
		state2 = false


func nearby_speaker(id):
	if id == speaker_id:
		if state1:
			
			if speaker_id == "skeletree1":
				set_text(string0)
			elif speaker_id == "skeletree2":
				set_text(string0B)
			elif speaker_id == "skeletree3":
				set_text(string0C)
			elif speaker_id == "skeletree4":
				set_text(string0D)
			control.visible = true
		

func deactivate_speaker(id):
	if id == speaker_id:
		control.visible = false


func speak_loop(id):
	pass 
	#if id == speaker_id:
		#while state2:
			#set_text(string1)
			#control.visible = true
			#await get_tree().create_timer(4).timeout
			#set_text(string2)
			#control.visible = true
			#await get_tree().create_timer(4).timeout
			#set_text(string3)
			#control.visible = true
			#await get_tree().create_timer(4).timeout
			#control.visible = false
			#await get_tree().create_timer(4).timeout
		#if state3:
			#set_text(string4)
			#control.visible = true
			
			
func check_state():
	if state1 == true:
		animate("grab_attention")
	elif state2 == true:
		animate("grab_attention")
	

func set_text(txt : String):
	speech_label.text = txt
	

func animate(mode : String):
	#tween = create_tween()
	
	match mode:
		"grab_attention":
			while(state1):
				var pos = skull.position
				var tweena = create_tween()
				tweena.tween_property(
					skull, "position",pos + Vector3(0,0.1,0),0.4
				)
				tweena.chain().tween_property(
					skull, "position",pos,0.4
				)
				await tweena.finished
		"conversation":
			pass
