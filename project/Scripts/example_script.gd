extends Node3D

var wowcube:WOWCube = null

var first_time_connect = false
var device_name : String
var device_id : String
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("send_msg_to_cube",write_to_device)
	new_cube()
	while (true):
		await get_tree().create_timer(29).timeout
		Events.emit_signal("cube_disconnected")
		await get_tree().create_timer(1).timeout
		device_name = wowcube.get_devices()[0].device_name
		device_id = wowcube.get_devices()[0].device_id
		wowcube.close_device(device_name,device_id)
		wowcube.open_device(device_name, device_id,"N4Uh8CKWIz")
		Events.emit_signal("cube_connected", "manual")

func new_cube():
	wowcube = WOWCube.new()
	wowcube.logging_level = 2
	wowcube.device_detected.connect(on_device_detected)
	wowcube.message_received.connect(on_message_received)
	wowcube.open()
	print("HEY" + str(wowcube.emulator_support))
	wowcube.emulator_support = false
	print("HEY" + str(wowcube.emulator_support))
	print("Wowcube version %s" % wowcube.get_version())


func on_device_detected(device:WOWDevice):
	print("Device detected name: %s id %s is connected %s" % [device.device_name, device.device_id, device.is_connected])
	call_deferred("emit_connected")
	wowcube.open_device(device.device_name, device.device_id,"N4Uh8CKWIz")

func on_message_received(device: WOWDevice, message_type: int, data: PackedByteArray):
	print("Message received from: %s Type: %d Data %s" % [device, message_type, data])
	if data != null:
		call_deferred("emit",data) 


func write_to_device(msg:String):
	var data: PackedByteArray = PackedByteArray([10,10,10])
	match msg:
		"fragment_on_tile":
			data = PackedByteArray([0x01, 0x02, 0x03, 0x04])
		"fragment_on_nearby_tile":
			data = PackedByteArray([0x01, 0x02, 0x03, 0x05])
	
	wowcube.write_to_device(device_name,device_id,data)


func emit_connected():
	Events.emit_signal("app_connected", "auto")


func emit(data):
	if int(data[0]) == 161:
		if(first_time_connect == false):
			Events.emit_signal("app_connected","(event)")
			first_time_connect = true
		Events.emit_signal("twist", int(data[2]), int(data[3]))
	elif int(data[0]) == 241:
		if(first_time_connect == false):
			Events.emit_signal("app_connected","(event)")
			first_time_connect = true
		Events.emit_signal("tap", int(data[2]))
