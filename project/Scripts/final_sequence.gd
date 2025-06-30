extends Area3D

@export var enter_event_name: String = ""

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Events.emit_signal(enter_event_name)
		Events.emit_signal("play_gravestone_animation","")


func _ready():
	Events.connect("all_frags_collected", final)

func final():
	var nod = get_child(0)
	nod.disabled = false
