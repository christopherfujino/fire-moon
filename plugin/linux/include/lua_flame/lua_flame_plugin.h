#ifndef FLUTTER_PLUGIN_LUA_FLAME_PLUGIN_H_
#define FLUTTER_PLUGIN_LUA_FLAME_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

#include <lua5.4/lua.h>
#include <lua5.4/lualib.h>
#include <lua5.4/lauxlib.h>

typedef struct GameState {
  unsigned int component_1_x;
  unsigned int component_1_y;
} GameState;

GameState setup_game_state(lua_State *state);

int move_right_thirty(lua_State *state);

void print_stacktrace();

void check_ok(int is_ok, lua_State *state);

typedef struct _LuaFlamePlugin LuaFlamePlugin;
typedef struct {
  GObjectClass parent_class;
} LuaFlamePluginClass;

FLUTTER_PLUGIN_EXPORT GType lua_flame_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void lua_flame_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS


#endif  // FLUTTER_PLUGIN_LUA_FLAME_PLUGIN_H_
