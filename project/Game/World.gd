
extends Node3D
const Cell = preload("res://Game/cell/cell_spotlight.tscn")
const Cell1 = preload("res://Game/dungeon_map_cells/cell_spotlight_01.tscn")
const Cell2 = preload("res://Game/dungeon_map_cells/cell_spotlight_02.tscn")
const Cell3 = preload("res://Game/dungeon_map_cells/cell_spotlight_03.tscn")
const Cell4 = preload("res://Game/dungeon_map_cells/cell_spotlight_04.tscn")

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
	var used_tiles = []
	used_tiles.append_array(used_tiles_1)
	used_tiles.append_array(used_tiles_2)
	used_tiles.append_array(used_tiles_3)
	used_tiles.append_array(used_tiles_4)
	
	map.free()
	
	make_cells(used_tiles_1,Cell1)
	make_cells(used_tiles_2,Cell2)
	make_cells(used_tiles_3,Cell3)
	make_cells(used_tiles_4,Cell4)
	

	for cell in cells.values():
		cell.update_faces(used_tiles)





func make_cells(tiles, instantiated_cell):
	for tile in tiles:
		print(tile)
		var cell = instantiated_cell.instantiate()
		add_child(cell)
		cell.owner = get_tree().edited_scene_root
		var key = [tile.x, tile.y]
		cell.init_tile_id(key)
		cells[key] = cell
		cell.global_transform.origin = Vector3(tile.x*Global.GRID_SIZE, 0, tile.y*Global.GRID_SIZE)
