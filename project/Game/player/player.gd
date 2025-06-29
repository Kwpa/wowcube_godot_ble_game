extends CharacterBody3D

@export var direction := Vector3.FORWARD
@export var rotation_time := 0.2

@onready var forward: = $Ray_front
@onready var camera = $Camera3D

@export var slide_curve : Curve
@export var warp_strength : float = 0.1

@onready var front_hover_pos = $front_hover_pos


var is_rotating := false
var is_moving := false

var is_facing_gap = false

const SPEED = 100

var current_tile : Node3D
var adjacent_tiles : Array[Node3D]
var world_ref


func _ready():
	Events.connect("twist", twist_input)
	Events.connect("tap", tap_input)
	world_ref = owner
	await get_tree().create_timer(1).timeout
	current_tile = world_ref.cells[[0,0]]


func collision_check(direction):
	if direction != null:
		return direction.is_colliding()
	else:
		return false


func move():
	if !forward.is_colliding():
		tween_onwards(direction,.4)
		step_to_new_tile(direction)
		#global_transform.origin.x += direction.x
		#global_transform.origin.z += direction.z


func step_to_new_tile(direction):
	var current_tile_id = current_tile.tile_id
	var new_id = [current_tile_id[0]+int(direction.x), current_tile_id[1]+int(direction.z)]
	current_tile = world_ref.cells[new_id]
	print(current_tile.tile_id)
	
	adjacent_tiles.clear()
	print("****** " + str(current_tile.tile_id))
	var adj_cells = world_ref.get_adjacent_cells(current_tile.tile_id)
	var cells = world_ref.cells
	if adj_cells != []:
		for cell_id in adj_cells:
			var key = [cell_id[0],cell_id[1]] 
			adjacent_tiles.append(world_ref.cells[key])
	
	check_for_fragments()

func check_for_fragments():
	if current_tile.has_fragment:
		Events.emit_signal("send_msg_to_cube","fragment_on_tile")
	else:
		for adj_tile in adjacent_tiles:
			if adj_tile.has_fragment:
				Events.emit_signal("send_msg_to_cube","fragment_on_nearby_tile")

func _input(event):
	if is_rotating:
		return
	if is_moving:
		return
	if event.is_action_pressed("ui_up"):
		Events.emit_signal("twist", 1,0) #move()
	if event.is_action_pressed("ui_left"):
		Events.emit_signal("twist", 1,1) #rotate_and_set_direction(90)
	if event.is_action_pressed("ui_right"):
		Events.emit_signal("twist", 2,1)
	if event.is_action_pressed("ui_down"):
		pass #rotate_and_set_direction(180)
	if event.is_action_pressed("Q"):
		Events.emit_signal("twist", 1,2)
	if event.is_action_pressed("E"):
		Events.emit_signal("twist", 2,2)
	if event.is_action_pressed("Left Shift"):
		Events.emit_signal("tap", 2)


func twist_input(scr : int, dir : int):
	var array = [scr,dir]
	match array:
		[1,0]:
			move()
		[2,0]:
			move()
		[1,1]:
			rotate_and_set_direction(90)
		[2,1]:
			rotate_and_set_direction(-90)
		[1,2]:
			print()
		[2,2]:
			print()


func tap_input(count : int):
	if count == 2:
		Events.emit_signal("shake_tile_elements", current_tile.tile_id, direction)
		warp_camera()
	
func warp_camera():
	var camera : Camera3D = get_child(0)
	var ori_fov = camera.fov
	var tween := create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_QUINT)
	tween.tween_method(
		func (progress):
		var curve_progress := slide_curve.sample(progress)
		camera.fov = ori_fov+warp_strength*curve_progress, 0.0, 1.0,2)


func rotate_and_set_direction(angle_delta: float):
	is_rotating = true
	var new_y = rotation_degrees.y + angle_delta
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees:y", new_y, rotation_time).set_ease(Tween.EASE_OUT)
	await tween.finished
	direction = -global_transform.basis.z.normalized()
	is_rotating = false


func tween_onwards(offset : Vector3, time : float):
	var original_pos = global_position
	var new_pos = global_position + offset
	var tween = create_tween()
	is_moving = true
	tween.tween_property(
		self, 
		"global_position", 
		new_pos, 
		time).set_ease(Tween.EASE_OUT)
	await tween.finished
	is_moving = false
