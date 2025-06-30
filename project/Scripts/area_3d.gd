extends Area3D

@export var enter_event_name: String = ""
@export var event_event_msg: String = ""
@export var exit_event_name: String = ""
@export var exit_event_msg: String = ""

func _on_body_entered(body: Node3D) -> void:
	Events.emit_signal(enter_event_name, event_event_msg)


func _on_body_exited(body: Node3D) -> void:
	Events.emit_signal(exit_event_name, exit_event_msg)
