
extends Node3D
const Cell = preload("res://Game/cell/cell_spotlight.tscn")
const Cell1 = preload("res://Game/dungeon_map_cells/cell_spotlight_01.tscn")
const Cell2 = preload("res://Game/dungeon_map_cells/cell_spotlight_02.tscn")
const Cell3 = preload("res://Game/dungeon_map_cells/cell_spotlight_03.tscn")
const Cell4 = preload("res://Game/dungeon_map_cells/cell_spotlight_04.tscn")
const Cell5 = preload("res://Game/dungeon_map_cells/fragment_tiles/fragment_tile_1.tscn")
const Cell6 = preload("res://Game/dungeon_map_cells/fragment_tiles/fragment_tile_2.tscn")
const Cell7 = preload("res://Game/dungeon_map_cells/fragment_tiles/fragment_tile_3.tscn")
const Cell8 = preload("res://Game/dungeon_map_cells/fragment_tiles/fragment_tile_4.tscn")
const Cell9 = preload("res://Game/dungeon_map_cells/graveyard_tile_1.tscn")
const Cell10 = preload("res://Game/dungeon_map_cells/graveyard_tile_2.tscn")
const Cell11 = preload("res://Game/dungeon_map_cells/graveyard_tile_3.tscn")
const Cell12 = preload("res://Game/dungeon_map_cells/graveyard_tile_4.tscn")
const Cell13 = preload("res://Game/dungeon_map_cells/graveyard_tile_4B.tscn")
const Cell14 = preload("res://Game/dungeon_map_cells/graveyard_tile_4C.tscn")

@export var Map: PackedScene

var cells : Dictionary

func _ready():
	print("here!")
	set_owner(get_tree().get_edited_scene_root())
	var map = Map.instantiate()
	var tile_map = map.get_tilemap()
	#var used_tiles = tile_map.get_used_cells()
	var used_tiles_1 = tile_map.get_used_cells_by_id(-1,Vector2i(0,0))
	var used_tiles_2 = tile_map.get_used_cells_by_id(-1,Vector2i(1,0))
	var used_tiles_3 = tile_map.get_used_cells_by_id(-1,Vector2i(2,0))
	var used_tiles_4 = tile_map.get_used_cells_by_id(-1,Vector2i(3,0))
	var used_tiles_5 = tile_map.get_used_cells_by_id(-1,Vector2i(0,1))
	var used_tiles_6 = tile_map.get_used_cells_by_id(-1,Vector2i(1,1))
	var used_tiles_7 = tile_map.get_used_cells_by_id(-1,Vector2i(2,1))
	var used_tiles_8 = tile_map.get_used_cells_by_id(-1,Vector2i(3,1))
	var used_tiles_9 = tile_map.get_used_cells_by_id(-1,Vector2i(0,2))
	var used_tiles_10 = tile_map.get_used_cells_by_id(-1,Vector2i(1,2))
	var used_tiles_11 = tile_map.get_used_cells_by_id(-1,Vector2i(2,2))
	var used_tiles_12 = tile_map.get_used_cells_by_id(-1,Vector2i(3,2))
	var used_tiles_13 = tile_map.get_used_cells_by_id(-1,Vector2i(3,3))
	var used_tiles_14 = tile_map.get_used_cells_by_id(-1,Vector2i(3,4))

	var used_tiles = []
	used_tiles.append_array(used_tiles_1)
	used_tiles.append_array(used_tiles_2)
	used_tiles.append_array(used_tiles_3)
	used_tiles.append_array(used_tiles_4)
	used_tiles.append_array(used_tiles_5)
	used_tiles.append_array(used_tiles_6)
	used_tiles.append_array(used_tiles_7)
	used_tiles.append_array(used_tiles_8)
	used_tiles.append_array(used_tiles_9)
	used_tiles.append_array(used_tiles_10)
	used_tiles.append_array(used_tiles_11)
	used_tiles.append_array(used_tiles_12)
	used_tiles.append_array(used_tiles_13)
	used_tiles.append_array(used_tiles_14)

	
	map.free()
	
	make_cells(used_tiles_1,Cell1)
	make_cells(used_tiles_2,Cell2)
	make_cells(used_tiles_3,Cell3)
	make_cells(used_tiles_4,Cell4)
	make_cells(used_tiles_5,Cell5)
	make_cells(used_tiles_6,Cell6)
	make_cells(used_tiles_7,Cell7)
	make_cells(used_tiles_8,Cell8)
	make_cells(used_tiles_9,Cell9)
	make_cells(used_tiles_10,Cell10)
	make_cells(used_tiles_11,Cell11)
	make_cells(used_tiles_12,Cell12)
	make_cells(used_tiles_13,Cell13)
	make_cells(used_tiles_14,Cell14)
	
	
	
	for cell in cells.values():
		cell.update_faces(used_tiles)
	
	await get_tree().create_timer(3).timeout

	Events.emit_signal("send_msg_to_cube","fragment_on_nearby_tile",0)
	Events.emit_signal("send_msg_to_cube","fragment_on_tile",0)
	
	
	#await get_tree().create_timer(3).timeout
	#Events.emit_signal("send_msg_to_cube","slot1_filled",1)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot1_filled",0)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot2_filled",1)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot2_filled",0)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot3_filled",1)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot3_filled",0)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot4_filled",1)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","slot4_filled",0)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","fragment_on_nearby_tile",1)
	#await get_tree().create_timer(6).timeout
	#Events.emit_signal("send_msg_to_cube","fragment_on_nearby_tile",0)
	#await get_tree().create_timer(2).timeout
	#Events.emit_signal("send_msg_to_cube","fragment_on_tile",1)
	#await get_tree().create_timer(6).timeout
	#Events.emit_signal("send_msg_to_cube","fragment_on_tile",0)


func get_adjacent_cells(input:Array) -> Array:
	var arr = []
	if cells.has([input[0]+1,input[1]]):
		arr.append([input[0]+1,input[1]])
	
	if cells.has([input[0],input[1]+1]):
		arr.append([input[0],input[1]+1])
	
	if cells.has([input[0]+1,input[1]+1]):
		arr.append([input[0]+1,input[1]+1])
	
	if cells.has([input[0]-1,input[1]]):
		arr.append([input[0]-1,input[1]])
	
	if cells.has([input[0],input[1]-1]):
		arr.append([input[0],input[1]-1])
	
	if cells.has([input[0]-1,input[1]-1]):
		arr.append([input[0]-1,input[1]-1])
	
	if cells.has([input[0]+1,input[1]-1]):
		arr.append([input[0]+1,input[1]-1])
	
	if cells.has([input[0]-1,input[1]+1]):
		arr.append([input[0]-1,input[1]+1])
		
	return arr


func make_cells(tiles, instantiated_cell):
	for tile in tiles:
		#print(tile)
		var cell = instantiated_cell.instantiate()
		add_child(cell)
		cell.owner = get_tree().edited_scene_root
		var key = [tile.x, tile.y]
		cell.init_tile_id(key)
		cells[key] = cell
		cell.global_transform.origin = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)
