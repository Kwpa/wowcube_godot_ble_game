#ifndef GODOT_WOWCUBE_H
#define GODOT_WOWCUBE_H

#include "core/object/ref_counted.h"
#include "WOWConnect.h"
#include "core/variant/dictionary.h"
#include "core/variant/typed_array.h"
#include "core/variant/array.h"
#include "core/string/ustring.h"
#include "wowdevice.h"
#include "core/templates/hash_map.h"

class WOWDevice;

class WOWCube : public RefCounted {
    GDCLASS(WOWCube, RefCounted);

protected:
    static void _bind_methods();

public:
    WOWCube();
    ~WOWCube();

    int logging_level = 1;
    void set_logging_level(int level = 1);
    int get_logging_level() const;
    String get_version() const;
    int get_last_error() const;
    String get_last_error_description() const;
    bool open();
    bool open_device(String device_name, String device_id, String cubeapp_uuid);
    void close_device(String device_name, String device_id);
    bool write_to_device(String device_name, String device_id, PackedByteArray data);
    void set_emulator_support(bool b);
    bool get_emulator_support();
    Array get_devices();
    HashMap<String, Ref<WOWDevice>> device_table;
    Ref<WOWDevice> get_device(const String &name, const String &id);

    static WOWCube *singleton;
};

#endif