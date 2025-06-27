extends Node

const GRID_SIZE = 1
enum MAP_COLLECTION {
	CAVE,
	SWAMP
}

var fragments_collected_count : int = 0

var fragments_collected : Dictionary[int,bool] = {
	1:false,
	2:false,
	3:false,
	4:false
}

func collect_fragment(id : int):
	fragments_collected[id] = true
	fragments_collected_count += 1


func get_total_fragments_collected() -> int:
	return fragments_collected_count
