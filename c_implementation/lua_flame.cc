#include <execinfo.h> // for backtrace()
#include <stdio.h> // for printf()
#include <stdlib.h> // for exit()
#include "dart_interop.h"

int main() {
  int is_ok = 0;
  lua_State *state = luaL_newstate();
  // open Lua stdlib
  luaL_openlibs(state);

  setup_globals(state);

  // Our Lua program
  const char *program = "print('2 * 3 is: ' .. multiplication(2, 3))";

  is_ok = luaL_loadstring(state, program);
  check_ok(is_ok, state);

  // LUA_MULTRET means option for multiple returns
  is_ok = lua_pcall(state, 0, LUA_MULTRET, 0);
  check_ok(is_ok, state);
  lua_pop(state, lua_gettop(state));

  lua_close(state);

  return 0;
}
