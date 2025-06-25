extends Node3D

@export var new_moon_phase_list : Array[Node]
@export var full_moon_phase_list : Array[Node]

var phase = "new_moon"

func _ready():
	Events.connect("twist",twist)
	for node in full_moon_phase_list:
		node.visible = false
	
	
func twist(i:int,j:int):
	match [i,j]:
		[1,2]:
			swap_phase()
		[2,2]:
			swap_phase()


func swap_phase():
	match phase:
		"new_moon":
			for node in new_moon_phase_list:
				node.visible = false
			for node in full_moon_phase_list:
				node.visible = true
			phase = "full_moon"
		"full_moon":
			for node in new_moon_phase_list:
				node.visible = true
			for node in full_moon_phase_list:
				node.visible = false
			phase = "new_moon"
