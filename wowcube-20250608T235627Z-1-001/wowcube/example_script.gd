extends Node3D

var wowcube:WOWCube = null

# Called when the node enters the scene tree for the first time.
func _ready():
	wowcube = WOWCube.new()
	wowcube.logging_level = 2
	wowcube.device_detected.connect(on_device_detected)
	wowcube.message_received.connect(on_message_received)
	wowcube.open()
	print("Wowcube version %s" % wowcube.get_version())

func on_device_detected(device:WOWDevice):
	print("Device detected name: %s id %s is connected %s" % [device.device_name, device.device_id, device.is_connected])

func on_message_received(device: WOWDevice, message_type: int, data: PackedByteArray):
	print("Message received from: %s Type: %d Data %s" % [device, message_type, data])
