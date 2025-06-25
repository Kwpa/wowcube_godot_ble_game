extends Node3D


@export var chance_over : int = 2
@export var chance : int = 3 
@export var spawn_locations : Array[Node]
@export var sprites : Array[Node3D]

func _ready():
	var rand = randi() % chance 
	visible = rand <= chance_over
	
	if spawn_locations.size() != 0:
		var rand_index = randi() % spawn_locations.size()
		for sprite in sprites:
			sprite.global_position = spawn_locations[rand_index].global_position
	
	var rand_bool = randi() % 4 < 1
	for sprite in sprites:
		sprite.flip_h = rand_bool
