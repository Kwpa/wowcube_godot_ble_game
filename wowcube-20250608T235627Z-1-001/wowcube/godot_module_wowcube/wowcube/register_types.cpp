#include "register_types.h"

#include "core/object/class_db.h"
#include "wowcube.h"
#include "wowdevice.h"

void initialize_wowcube_module(ModuleInitializationLevel p_level) {
#ifdef TOOLS_ENABLED
	if (p_level == MODULE_INITIALIZATION_LEVEL_EDITOR) {
	}
#endif

 	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
 			return;
   }
 	ClassDB::register_class<WOWCube>();
 	ClassDB::register_class<WOWDevice>();
}

void uninitialize_wowcube_module(ModuleInitializationLevel p_level) {
 	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
 			return;
   }
   // Nothing to do here in this example.
}