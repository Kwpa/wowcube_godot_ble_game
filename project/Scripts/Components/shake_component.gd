extends Node3D

@export var slide_curve : Curve
@export var all_shaking_elements : Array[Node3D]
@export var shake_strength : float = 2


func _ready():
	Events.connect("shake_tile_elements", shake)


func shake(tile_id : Array, direction : Vector3i):
	if self.get_parent().tile_id[0] == tile_id[0] and self.get_parent().tile_id[1] == tile_id[1]:
		
		var north : Array[Node3D]
		var east : Array[Node3D]
		var south : Array[Node3D]
		var west : Array[Node3D]
		
		for el in all_shaking_elements:
			if el != null:
				if el.position.x > 0:
					west.append(el)
				elif el.position.x < 0: 
					east.append(el)
				if el.position.z > 0:
					north.append(el)
				elif el.position.z < 0:
					south.append(el)
		
		var list = []
		match direction:
			Vector3i(0,0,1):
				list = north
			Vector3i(1,0,0):
				list = west
			Vector3i(0,0,-1):
				list = south
			Vector3i(-1,0,0):
				list = east
		for item in list:
			if item != null:
				var pos = item.position
				var tween := create_tween()
				tween.set_trans(Tween.TransitionType.TRANS_QUINT)
				tween.chain().tween_method(
					func (progress):
					var curve_progress := slide_curve.sample(progress)
					item.position = pos+Vector3(shake_strength*curve_progress,0,0), 0.0, 1.0,2)
		
		
