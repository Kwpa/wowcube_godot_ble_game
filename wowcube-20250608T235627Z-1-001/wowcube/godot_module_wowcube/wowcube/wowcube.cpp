#include "wowcube.h"
#include "wowdevice.h"
#include "core/templates/hash_map.h"

WOWCube *WOWCube::singleton = nullptr;

void WOWCube::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_version"), &WOWCube::get_version);
    
    ClassDB::bind_method(D_METHOD("get_last_error"), &WOWCube::get_last_error);
    ClassDB::bind_method(D_METHOD("get_last_error_description"), &WOWCube::get_last_error_description);
    ClassDB::bind_method(D_METHOD("open"), &WOWCube::open);
    ClassDB::bind_method(D_METHOD("open_device", "device_name", "device_id", "cubeapp_uuid"), &WOWCube::open_device);
    ClassDB::bind_method(D_METHOD("close_device", "device_name", "device_id"), &WOWCube::close_device);
    ClassDB::bind_method(D_METHOD("write_to_device", "device_name", "device_id", "data"), &WOWCube::write_to_device);

    ClassDB::bind_method(D_METHOD("set_logging_level", "level"), &WOWCube::set_logging_level, DEFVAL(0));
    ClassDB::bind_method(D_METHOD("get_logging_level"), &WOWCube::get_logging_level);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "logging_level"), "set_logging_level", "get_logging_level");

    ClassDB::bind_method(D_METHOD("get_devices"), &WOWCube::get_devices);

    ADD_SIGNAL(MethodInfo("wowcube_log", PropertyInfo(Variant::INT, "level"), PropertyInfo(Variant::STRING, "message")));
    ADD_SIGNAL(MethodInfo("device_detected",  PropertyInfo(Variant::OBJECT, "device", PROPERTY_HINT_RESOURCE_TYPE, "WOWDevice")));
    ADD_SIGNAL(MethodInfo("message_received", PropertyInfo(Variant::OBJECT, "device", PROPERTY_HINT_RESOURCE_TYPE, "WOWDevice"), PropertyInfo(Variant::INT, "message_type"), PropertyInfo(Variant::PACKED_BYTE_ARRAY, "data")));
}

WOWCube::WOWCube() {
    singleton = this;
}

WOWCube::~WOWCube() {
    singleton = nullptr;
    device_table.clear();
}

void WOWCube::set_logging_level(int level) {
    logging_level = level;
}

int WOWCube::get_logging_level() const {
    return logging_level;
}

String WOWCube::get_version() const {
    return String(wowonnect_get_version());
}

Array WOWCube::get_devices() {
    Array devices;
    for (const auto& device : device_table) {
        devices.append(device.value);
    }
    return devices;
}

int WOWCube::get_last_error() const {
    return wowconnect_get_last_error();
}

String WOWCube::get_last_error_description() const {
    return String(wowconnect_get_last_error_description());
}

bool WOWCube::open_device(String device_name, String device_id, String cubeapp_uuid) {
    wowconnect_device_t device = {};
    device.IsConnected = false;
    strncpy_s(device.Name, device_name.utf8().get_data(), sizeof(device.Name) - 1);
    strncpy_s(device.Id, device_id.utf8().get_data(), sizeof(device.Id) - 1);
    return wowconnect_open_device(device, cubeapp_uuid.utf8().get_data());
}

void WOWCube::close_device(String device_name, String device_id) {
    wowconnect_device_t device = {};
    device.IsConnected = true;
    strncpy_s(device.Name, device_name.utf8().get_data(), sizeof(device.Name) - 1);
    strncpy_s(device.Id, device_id.utf8().get_data(), sizeof(device.Id) - 1);
    wowconnect_close_device(device);
}

bool WOWCube::write_to_device(String device_name, String device_id, PackedByteArray data) {
    wowconnect_device_t device = {};
    device.IsConnected = true;
    strncpy_s(device.Name, device_name.utf8().get_data(), sizeof(device.Name) - 1);
    strncpy_s(device.Id, device_id.utf8().get_data(), sizeof(device.Id) - 1);
    Vector<uint8_t> vec = data;
    return wowconnect_write_to_device(device, vec.ptr(), vec.size());
}

Ref<WOWDevice> WOWCube::get_device(const String &name, const String &id) {
    String key = id + "|" + name;
    if (device_table.has(key)) {
        return device_table[key];
    }
    return nullptr;
}

static void wowcube_log_delegate(wowconnect_log_level_t level, const char* message) {
    if (WOWCube::singleton) {
        String msg = String(message);
        if (level == 0 && msg.begins_with("Device enumeration completed")) {
            return;
        }
        WOWCube::singleton->emit_signal("wowcube_log", (int)level, msg);
        if (level == 1 || WOWCube::singleton->get_logging_level() >= 1) {
            print_line(String("WOWCube Log: ") + msg);
        }
    }
}

static void wowcube_device_detected_delegate(wowconnect_device_t device) {
    if (WOWCube::singleton) {
        Ref<WOWDevice> dev = WOWDevice::get_or_create(String(device.Name), String(device.Id), device.IsConnected);
        WOWCube::singleton->emit_signal("device_detected", dev);
        if (WOWCube::singleton->get_logging_level() >= 1) {
            print_line(vformat("WOWCube Device Detected. Name: %s, Id: %s, IsConnected: %s", String(device.Name), String(device.Id), device.IsConnected ? "true" : "false"));
        }
    }
}

static void wowcube_message_received_delegate(wowconnect_device_t device, unsigned char messageType, unsigned char* data, int dataSize) {
    if (WOWCube::singleton) {
        Ref<WOWDevice> dev = WOWDevice::get_or_create(String(device.Name), String(device.Id), device.IsConnected);
        PackedByteArray arr;
        arr.resize(dataSize);
        for (int i = 0; i < dataSize; i++) {
            arr.set(i, data[i]);
        }
        WOWCube::singleton->emit_signal("message_received", dev, (int)messageType, arr);
        if (WOWCube::singleton->get_logging_level() >= 2) {
            print_line(vformat("WOWCube Message Received From Name: %s, Id: %s, Type: %d, Raw data: %s", String(device.Name), String(device.Id), messageType, arr));
        } else if (WOWCube::singleton->get_logging_level() >= 1) {
            print_line(vformat("WOWCube Message Received From Name: %s, Id: %s, Type: %d", String(device.Name), String(device.Id), messageType));
        }
    }
}

bool WOWCube::open() {
    return wowconnect_open(
        wowcube_device_detected_delegate,
        wowcube_message_received_delegate,
        wowcube_log_delegate
    );
}
