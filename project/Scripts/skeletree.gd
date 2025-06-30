extends Sprite3D

@onready var skull = $skull
@onready var sounds : AudioStreamPlayer3D = $sounds

var tween : Tween

func _ready():
	Events.connect("animate_skeletree", animate)
	animate("grab_attention")


func animate(mode : String):
	#tween = create_tween()
	
	match mode:
		"grab_attention":
			pass
		"conversation":
			pass
