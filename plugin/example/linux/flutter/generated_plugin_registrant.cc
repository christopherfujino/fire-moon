//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <lua_flame/lua_flame_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) lua_flame_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "LuaFlamePlugin");
  lua_flame_plugin_register_with_registrar(lua_flame_registrar);
}
