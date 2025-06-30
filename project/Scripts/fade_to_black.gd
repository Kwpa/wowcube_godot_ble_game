extends ColorRect


func _ready():
	Events.connect("all_frags_collected", fade)
	Events.connect("final", fadeaway)



func fade():
	var tween = create_tween()
	tween.tween_property(
		self,
		"modulate",
		Color(0,0,0,1),
		1
	)
	tween.chain().tween_property(
		self,
		"modulate",
		Color(0,0,0,1),
		2
	)
	tween.chain().tween_property(
		self,
		"modulate",
		Color(0,0,0,0),
		1
	)
	
	
func fadeup():
	await get_tree().create_timer(2).timeout
	var tween = create_tween()
	tween.tween_property(
		self,
		"modulate",
		Color(0,0,0,0),
		1
	)
	await tween.finished
	$Control.visible = false


func fadeaway():
	
	await get_tree().create_timer(5).timeout
	var tween = create_tween()
	tween.tween_property(
		self,
		"modulate",
		Color(1,1,1,1),
		1
	)
	var tween2 = create_tween()
	tween2.tween_property(
		get_child(0),
		"modulate",
		Color(1,1,1,1),
		1
	)
	await tween2.finished
	await get_tree().create_timer(10).timeout
	var tween3 = create_tween()
	tween3.tween_property(
		get_child(0),
		"modulate",
		Color(1,1,1,0),
		1
	)
	



func _on_button_pressed() -> void:
	Events.emit_signal("select_mode",false)
	fadeup()
	$"../Button".visible = false


func _on_button_2_pressed() -> void:
	Events.emit_signal("select_mode",true)
	fadeup()
	$"../Button".visible=true
