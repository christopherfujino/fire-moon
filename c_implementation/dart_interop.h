#ifndef DART_INTEROP_H_
#define DART_INTEROP_H_

#include <lua5.4/lua.h>
#include <lua5.4/lualib.h>
#include <lua5.4/lauxlib.h>

int multiplication(lua_State *state);

void register_functions(lua_State *state);

void setup_globals(lua_State *state);

void print_stacktrace();

void check_ok(int is_ok, lua_State *state);

#endif // DART_INTEROP_H_
