extends Node3D


@export var north : Array[Node3D]
@export var east : Array[Node3D]
@export var south : Array[Node3D]
@export var west : Array[Node3D]
@export var slide_curve : Curve

@export var shake_strength : float = 2


func _ready():
	Events.connect("shake_tile_elements", shake)


func shake(tile_id : Array, direction : Vector3i):
	if self.get_parent().tile_id[0] == tile_id[0] and self.get_parent().tile_id[1] == tile_id[1]:
		var list = []
		match direction:
			Vector3i(0,0,1):
				list = north
			Vector3i(1,0,0):
				list = east
			Vector3i(0,0,-1):
				list = south
			Vector3i(-1,0,0):
				list = west
		for item in list:
			var pos = item.position
			var tween := create_tween()
			tween.set_trans(Tween.TransitionType.TRANS_QUINT)
			tween.chain().tween_method(
				func (progress):
				var curve_progress := slide_curve.sample(progress)
				item.position = pos+Vector3(shake_strength*curve_progress,0,0), 0.0, 1.0,2)
		
		
