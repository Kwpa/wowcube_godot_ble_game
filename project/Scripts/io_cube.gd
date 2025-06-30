extends Node3D

## this is the identifier of the cubeapp application that will interact with this program
const CUBEAPP_UUID = "N4Uh8CKWIz"

var run_loop = true
var found_devices_count:int = 0
var found_devices:Array[WOWDevice] = []
var waiting_for_data_from_wow_cube:bool = false
var wowcube:WOWCube = null
var first_time_connect = false
var ignore_wowcube = true

var sending_msg : bool = false
var out_data: PackedByteArray = PackedByteArray([0,0,0,0])

func wowcube_log(level:int, message:String):
	if level == 0:
		print(message)
	elif level == 1:
		printerr(message)

func message_received(device:WOWDevice, message_type:int, data:PackedByteArray):
	print("Received data from device %s id %s" % [device.device_name, device.device_id])
	print("Message Type %d" % message_type)
	print("Data size %d" % data.size())
	print("Data: %s" % var_to_str(data))
	if data != null:
		call_deferred("emit",data) 


func device_detected(device:WOWDevice):
	found_devices.push_back(device)
	found_devices_count += 1
	call_deferred("emit_connected")


func _ready():
	Events.connect("send_msg_to_cube",write_to_device)
	Events.connect("select_mode",custom_init)

func custom_init(b:bool):
	ignore_wowcube = b
	if ignore_wowcube: return
	await get_tree().process_frame
	wowcube = WOWCube.new()
	wowcube.device_detected.connect(device_detected)
	wowcube.wowcube_log.connect(wowcube_log)
	wowcube.message_received.connect(message_received)

	print("WowConnect version %s" % wowcube.get_version())

	if wowcube.open():
		print("WOWConnect library is opened")
	else:
		printerr("WOW Connect failed to open with error %s" % wowcube.get_last_error_description())
		if ignore_wowcube:
			return

	while (run_loop and is_inside_tree()):
		await get_tree().process_frame
		if (found_devices_count == 1 and is_inside_tree()):
			if not waiting_for_data_from_wow_cube:
				if wowcube.open_device(found_devices[0].device_name, found_devices[0].device_id, CUBEAPP_UUID):
					print("Device %s is opened" % found_devices[0].device_name)
					if sending_msg:
						if wowcube.write_to_device(found_devices[0].device_name, found_devices[0].device_id, out_data):
							print(str(out_data) + " **** Data was successfully written to %s" % found_devices[0].device_name)
							waiting_for_data_from_wow_cube = true
							print("Waiting for data from wow cube")
						else:
							printerr("Write operation to device %s has failed with error %s" % [found_devices[0].device_name, wowcube.get_last_error_description()])
						out_data = PackedByteArray([0,0,0,0])
						sending_msg = false
				else:
					Events.emit_signal("error")
					printerr("Wow connect failed to open device %s with error %s" % [found_devices[0].device_name, wowcube.get_last_error_description()])
					if ignore_wowcube:
						return
			else:
				if sending_msg:
					if wowcube.write_to_device(found_devices[0].device_name, found_devices[0].device_id, out_data):
						print(str(out_data) + " **** Data was successfully written to %s" % found_devices[0].device_name)
						waiting_for_data_from_wow_cube = true
						print("Waiting for data from wow cube")
					else:
						printerr("Write operation to device %s has failed with error %s" % [found_devices[0].device_name, wowcube.get_last_error_description()])
					out_data = PackedByteArray([0,0,0,0])
					sending_msg = false

var delta_total :float = 0

func _process(delta):
	if ignore_wowcube == false:
		delta_total += delta
		if delta_total >= 29.0:
			Events.emit_signal("cube_disconnected")
			wowcube.close_device(found_devices[0].device_name,found_devices[0].device_id)
			wowcube.open_device(found_devices[0].device_name,found_devices[0].device_id,CUBEAPP_UUID)
			Events.emit_signal("cube_connected", "manual")
			delta_total = 0

func write_to_device(msg:String, val:int):
	match msg:
		"connected":
			out_data = PackedByteArray([0,val,0,0])
		"slot1_filled":
			out_data = PackedByteArray([1,val,0,0])
		"slot2_filled":
			out_data = PackedByteArray([2,val,0,0])
		"slot3_filled":
			out_data = PackedByteArray([3,val,0,0])
		"slot4_filled":
			out_data = PackedByteArray([4,val,0,0])
		"fragment_on_nearby_tile":
			out_data = PackedByteArray([5,val,0,0])
		"fragment_on_tile":
			out_data = PackedByteArray([6,val,0,0])
	sending_msg = true

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

func emit_connected():
	write_to_device("connected",1)
	Events.emit_signal("app_connected", "auto")


func _on_button_pressed() -> void:
	custom_init(false)
	$"../Button".visible=false
