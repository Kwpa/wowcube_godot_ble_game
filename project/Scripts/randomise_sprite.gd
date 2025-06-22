extends Node3D


@export var chance_over : int = 2
@export var chance : int = 3 


func _ready():
	var rand = randi() % chance 
	visible = rand <= chance_over
	
	if get_child_count() != 0:
		var rand_index = randi() % get_children().size()
		self.global_position = get_children()[rand_index].global_position
	
	self.flip_h = randi() % 4 < 1 
