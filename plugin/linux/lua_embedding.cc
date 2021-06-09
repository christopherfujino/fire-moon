#include <lua5.4/lua.h>
#include <lua5.4/lualib.h>
#include <lua5.4/lauxlib.h>

#include <execinfo.h> // for backtrace()
#include <stdio.h> // for printf()
#include <stdlib.h> // for exit()

#include "include/lua_flame/lua_flame_plugin.h"

GameState game_state = {
  .component_1_x = 0,
  .component_1_y = 0,
};

// To be invoked from Lua
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int move_right_thirty(lua_State *state) {
  //// Check if the first argument is integer and return the value
  //int a = luaL_checkinteger(state, 1);

  //// Check if the second argument is integer and return the value
  //int b = luaL_checkinteger(state, 2);

  //lua_Integer c = a * b;

  //// Push the result to the Lua stack.
  //lua_pushinteger(state, c);

  // 1 == successful, else error
  return 1;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void call_lua_func(lua_State *state, char *function_name) {
  // push global function "init" to top of stack
  lua_getglobal(state, function_name);
  // lua_call(state, nargs, nreturnvalues);
  lua_call(state, 0, 0);
}

// To be invoked from Dart
extern "C" __attribute__((visibility("default"))) __attribute__((used))
GameState setup_game_state(lua_State *state) {
  // TODO initialize from Lua program
  return game_state;
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void print_stacktrace() {
  const int STACK_BUFFER_LENGTH = 25;

  // Stacktrace code inspired by:
  //   http://www.gnu.org/software/libc/manual/html_node/Backtraces.html

  // Create an array of STACK_BUFFER_LENGTH void pointers
  void *buffer[STACK_BUFFER_LENGTH];

  int stacktrace_size = backtrace(buffer, STACK_BUFFER_LENGTH);

  // Create a pointer to char pointers (~array of strings)
  char **strings = NULL;

  // heap allocation that gets assigned to strings
  strings = backtrace_symbols(buffer, stacktrace_size);

  if (strings != NULL) {
    // This will be used to execute addr2line
    char command[256];
    for (int i = 0; i < stacktrace_size; i++) {
      fprintf(
        stderr,
        "%2i: %s\n",
        i + 1,
        strings[i]
      );

      /* find first occurence of '(' or ' ' in message[i] and assume
       * everything before that is the file name. (Don't go beyond 0 though
       * (string terminator)*/
      size_t p = 0;
      while(strings[i][p] != '(' && strings[i][p] != ' '
          && strings[i][p] != 0) {
        ++p;
      }

      sprintf(
        command,
        "addr2line %p -e %.*s",
        buffer[i],
        // cast from size_t (unsigned long) -> int
        (int) p,
        strings[i]
      );
      system(command);
    }
    // free the allocation
    free(strings);
  }
}

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void check_ok(int is_ok, lua_State *state) {
  if (is_ok != LUA_OK) {
    print_stacktrace();

    fprintf(stderr, "Oops! Error code: %i\n", is_ok);
    lua_close(state);
    exit(1);
  }
}
