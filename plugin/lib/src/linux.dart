import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pffi;

import '../lua_flame.dart' show checkOk, dynamicLibrary, lib, LuaFlame;
import './generated_bindings.dart' as bindings;

/// Create a Pointer<Int8> from a String.
///
/// This pointer must be freed by malloc.
ffi.Pointer<ffi.Int8> _stringToCharStar(String str) {
  return str.toNativeUtf8(allocator: pffi.malloc).cast<ffi.Int8>();
}

void _luaPop(ffi.Pointer<bindings.lua_State> state, int n) {
  // #define lua_pop(L,n)		lua_settop(L, -(n)-1)
  lib.lua_settop(state, -(n) - 1);
}

/// Linux-specific Implementation of a LuaFlame game.
class LinuxLuaFlame extends LuaFlame {
  LinuxLuaFlame(this.program);

  // Lua VM state
  ffi.Pointer<bindings.lua_State>? state;

  final String program;

  Future<void> onLoad() {
    final superFuture = super.onLoad();

    _setupVm();
    _loadProgramToVm(program);
    _invokeFunction();
    _callCFunction('initialize');

    return superFuture;
  }

  void _setupVm() {
    state = lib.luaL_newstate();

    // open Lua stdlib
    lib.luaL_openlibs(state!);

    // setup globals
    lib.lua_pushinteger(state!, 42);

    ffi.Pointer<ffi.Int8> charPtr = _stringToCharStar("answer");
    lib.lua_setglobal(state!, charPtr);
    pffi.malloc.free(charPtr);

    // Push the pointer to the function
    final moveRightThirtyPointer = dynamicLibrary.lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<bindings.lua_State>)>>("move_right_thirty");
    lib.lua_pushcclosure(state!, moveRightThirtyPointer, 0);
    charPtr = _stringToCharStar("move_right_thirty");
    lib.lua_setglobal(state!, charPtr);
    pffi.malloc.free(charPtr);
  }

  void _loadProgramToVm(String program) {
    // convert program from String -> ffi.Pointer<ffi.Int8>
    final programPtr = _stringToCharStar(program);
    final int ok = lib.luaL_loadstring(state!, programPtr);
    checkOk(ok);
    pffi.malloc.free(programPtr);
  }

  void _invokeFunction() {
    // invoke function at the top of the stack

    // LUA_MULTRET means option for multiple returns
    final int ok = lib.lua_pcallk(state!, 0, bindings.LUA_MULTRET, 0, 0, ffi.nullptr);
    checkOk(ok);

    // Pop off the top of the stack

    // #define lua_pop(L,n)		lua_settop(L, -(n)-1)
    final int top = lib.lua_gettop(state!);
    lib.lua_settop(state!, -(top) - 1); // is this correct?
  }

  void onDetach() {
    super.onDetach();

    lib.lua_close(state!);
    state = null;
  }

  void _callCFunction(String name) {
    final ffi.Pointer<ffi.Int8> namePtr = _stringToCharStar(name);
    lib.lua_getglobal(state!, namePtr);
    pffi.malloc.free(namePtr);

    lib.lua_callk(state!, 0, 0, 0, ffi.nullptr);
  }

  void update(double t) {
    _callCFunction('update');

    ffi.Pointer<ffi.Int8> ptr = _stringToCharStar('component_0_x');
    lib.lua_getglobal(state!, ptr);
    final double x = lib.lua_tonumberx(state!, -1, ffi.nullptr);
    _luaPop(state!, 1);
    pffi.malloc.free(ptr);

    ptr = _stringToCharStar('component_0_y');
    lib.lua_getglobal(state!, ptr);
    final double y = lib.lua_tonumberx(state!, -1, ffi.nullptr);
    _luaPop(state!, 1);
    pffi.malloc.free(ptr);

    final double xDiff = x - player.left;
    final double yDiff = y - player.top;
    if (xDiff != 0 || yDiff != 0) {
      player = player.translate(xDiff, yDiff);
    }
    print('coordinates ($x, $y)');
  }
}

/*
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

   */
