extends Node3D
class_name SliceableComponent

@export var base_sprite : Sprite3D
@export var split_sprite_top : Sprite3D
@export var split_sprite_bottom : Sprite3D

@export var slice_distance : float = 1

@export var slide_curve : Curve

@export var travel_time : float = 1


var is_slicing = false

func _ready():
	await get_tree().create_timer(2).timeout 
	move_closer_to_player()
	await get_tree().create_timer(1).timeout
	slice()

func slice():
	base_sprite.visible = false
	split_sprite_top.visible = true
	split_sprite_bottom.visible = true
	is_slicing = true
	tween_slice(split_sprite_top, slice_distance)
	tween_slice(split_sprite_bottom, -slice_distance)
	await get_tree().create_timer(travel_time).timeout 
	is_slicing = false


func tween_slice(sprite, direction : float):
	var start_global : Vector3 = sprite.position
	var final_pos : Vector3 = start_global + Vector3(0,0,direction)
	var tween := create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_QUINT)
	tween.tween_method(
		func (progress):
		var curve_progress := slide_curve.sample(progress)
		sprite.position = lerp(start_global, final_pos, curve_progress), 0.0, 1.0, travel_time)
	tween.parallel().tween_property(
		sprite,
		"modulate",
		Color(1,1,1,0),
		travel_time
	).set_trans(Tween.TRANS_SINE)
	#await tween.finished
	is_slicing = false


@onready var player = get_tree().get_nodes_in_group("Player")[0]

func move_closer_to_player():
	var glob = global_position
	var glob2 = player.global_position
	var direction_enemy_to_player = (glob2-glob).normalized()
	var new_pos = glob + direction_enemy_to_player * 1
	var tween = create_tween()
	
	tween.tween_property(
		self.get_parent_node_3d(), 
		"global_position", 
		new_pos, 
		.5).set_trans(Tween.TRANS_CUBIC)
	#tween.parallel().tween_property()
	#await tween.finished
	#is_slicing = false

#
#
#func tween move(sprite : Sprite3D, original_position : Vector3, offset : Vector3, time : float):
	#var new_pos = sprite.global_position + offset
	#var tween = create_tween()
	#is_slicing = true
	#tween.tween_property(
		#sprite, 
		#"global_position", 
		#new_pos, 
		#time).set_ease(Tween.EaseType.EASE_IN)
	#tween.parallel().tween_property()
	#await tween.finished
	#is_slicing = false
