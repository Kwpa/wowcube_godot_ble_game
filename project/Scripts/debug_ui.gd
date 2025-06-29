extends Control
@onready var con = $vbox/connected
@onready var cubcon = $vbox/cube_connected
@onready var dis = $vbox/disconnected


func _ready():
	Events.connect("app_connected", app_connect)
	Events.connect("cube_connected", cube_connect)
	Events.connect("cube_disconnected", cube_disconnect)

func app_connect(msg:String):
	con.get_child(0).text = "app connected: " + msg
	fade_in_out_label(con)
	

func cube_connect(msg:String):
	cubcon.get_child(0).text = "cube connected: " + msg
	fade_in_out_label(cubcon)
	

func cube_disconnect():
	fade_in_out_label(dis)

func fade_in_out_label(element:Control):
	var tween = create_tween()
	tween.tween_property(
		element, 
		"modulate", 
		Color(1,1,1,1), 
		1).set_ease(Tween.EaseType.EASE_IN)
	await tween.finished
	await get_tree().create_timer(1).timeout
	var tween2 = create_tween()
	tween2.tween_property(
		element, 
		"modulate", 
		Color(1,1,1,0), 
		1)
