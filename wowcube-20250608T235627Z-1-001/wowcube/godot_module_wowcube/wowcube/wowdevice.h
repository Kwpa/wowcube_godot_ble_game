#ifndef GODOT_WOWDEVICE_H
#define GODOT_WOWDEVICE_H

#include "core/object/ref_counted.h"
#include "WOWConnect.h"
#include "core/variant/dictionary.h"
#include "core/variant/typed_array.h"
#include "core/variant/array.h"
#include "core/string/ustring.h"

class WOWCube;

class WOWDevice : public RefCounted {
    GDCLASS(WOWDevice, RefCounted);
protected:
    static void _bind_methods();

public:

    String device_name;
    String device_id;
    bool is_connected = false;

    void set_device_name(String name);
    String get_device_name() const;

    void set_device_id(String id);
    String get_device_id() const;

    void set_is_connected(bool connected);
    bool get_is_connected() const;
    
    bool open_device(String cubeapp_uuid);
    void close_device();
    bool write_to_device(PackedByteArray data);

    static Ref<WOWDevice> get_or_create(const String &name, const String &id, bool is_connected);

    WOWDevice();
    ~WOWDevice();
};

#endif