extends Node3D

@onready var start = $start
@onready var fragment_sprite = $fragment_sprite
@onready var player = get_tree().get_nodes_in_group("Player")[0]

@export var slide_curve : Curve
@export var travel_time : float = 1.0
@export var fragment_id : int = 0
@export var fragment_direction1 : Vector3i
@export var fragment_direction2 : Vector3i

func _ready():
	Events.connect("reveal_fragment", reveal_frag)


func reveal_frag(id : int):
	if id == fragment_id and Global.fragments_collected[fragment_id] == false:
		appear_from_hiding()
	pass
	
func appear_from_hiding():
	fragment_sprite.visible = true
	fragment_sprite.get_child(fragment_id).visible = true
	
	var start_global = fragment_sprite.global_position
	
	var final_pos = player.front_hover_pos.global_position
	var tween := create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_QUINT)
	tween.tween_method(
		func (progress):
		var curve_progress := slide_curve.sample(progress)
		fragment_sprite.global_position = lerp(start_global, final_pos, curve_progress), 0.0, 1.0, travel_time)
	await tween.finished
	fragment_sprite.get_child(fragment_id).get_child(1).visible = true
	fragment_sprite.get_child(fragment_id).get_child(1).emitting = true
	await get_tree().create_timer(1).timeout
	fragment_sprite.visible = false 
	Events.emit_signal("fragment_collected", fragment_id) 
	
	Global.collect_fragment(fragment_id)
	
