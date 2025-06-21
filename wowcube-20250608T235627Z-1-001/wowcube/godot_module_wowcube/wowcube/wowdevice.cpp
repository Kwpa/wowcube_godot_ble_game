#include "wowdevice.h"
#include "wowcube.h"

#include "core/object/class_db.h"
#include "core/variant/variant.h"

WOWDevice::WOWDevice() {}
WOWDevice::~WOWDevice() {}

void WOWDevice::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_device_name", "name"), &WOWDevice::set_device_name);
    ClassDB::bind_method(D_METHOD("get_device_name"), &WOWDevice::get_device_name);
    ClassDB::bind_method(D_METHOD("set_device_id", "id"), &WOWDevice::set_device_id);
    ClassDB::bind_method(D_METHOD("get_device_id"), &WOWDevice::get_device_id);
    ClassDB::bind_method(D_METHOD("set_is_connected", "connected"), &WOWDevice::set_is_connected);
    ClassDB::bind_method(D_METHOD("get_is_connected"), &WOWDevice::get_is_connected);
    ClassDB::bind_method(D_METHOD("open_device", "cubeapp_uuid"), &WOWDevice::open_device);
    ClassDB::bind_method(D_METHOD("close_device"), &WOWDevice::close_device);
    ClassDB::bind_method(D_METHOD("write_to_device", "data"), &WOWDevice::write_to_device);

    ADD_PROPERTY(PropertyInfo(Variant::STRING, "device_name"), "set_device_name", "get_device_name");
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "device_id"), "set_device_id", "get_device_id");
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "is_connected"), "set_is_connected", "get_is_connected");
}

void WOWDevice::set_device_name(String name) { device_name = name; }
String WOWDevice::get_device_name() const { return device_name; }
void WOWDevice::set_device_id(String id) { device_id = id; }
String WOWDevice::get_device_id() const { return device_id; }
void WOWDevice::set_is_connected(bool connected) { is_connected = connected; }
bool WOWDevice::get_is_connected() const { return is_connected; }

bool WOWDevice::open_device(String cubeapp_uuid) {
    if (WOWCube::singleton) {
        return WOWCube::singleton->open_device(device_name, device_id, cubeapp_uuid);
    }
    return false;
}

void WOWDevice::close_device() {
    if (WOWCube::singleton) {
        WOWCube::singleton->close_device(device_name, device_id);
    }
}

bool WOWDevice::write_to_device(PackedByteArray data) {
    if (WOWCube::singleton) {
        return WOWCube::singleton->write_to_device(device_name, device_id, data);
    }
    return false;
}

// Factory: get or create a device by name/id
Ref<WOWDevice> WOWDevice::get_or_create(const String &name, const String &id, bool is_connected) {
    if (!WOWCube::singleton) return nullptr;
    String key = id + "|" + name;
    if (!WOWCube::singleton->device_table.has(key)) {
        Ref<WOWDevice> dev = memnew(WOWDevice());
        dev->set_device_name(name);
        dev->set_device_id(id);
        dev->set_is_connected(is_connected);
        WOWCube::singleton->device_table[key] = dev;
        return dev;
    }
    Ref<WOWDevice> dev = WOWCube::singleton->device_table[key];
    dev->set_is_connected(is_connected);
    return dev;
}
