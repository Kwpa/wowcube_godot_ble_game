extends TextureRect

func _ready():
	var original_pos = position
	var new_pos = position + Vector2(0,20)
	while(true):
		var tween = create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(
			self, 
			"position", 
			new_pos, 
			3)
		tween.chain().tween_property(
			self, 
			"position", 
			original_pos, 
			3)
		await tween.finished

		
