import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

import 'package:flame/game.dart' as game;
import 'package:flutter/widgets.dart' as widgets;

import './src/linux.dart' show LinuxLuaFlame;
export './src/linux.dart';

import './src/generated_bindings.dart' as bindings;

abstract class LuaFlame extends game.Game {
  LuaFlame();

  Future<void> onLoad() async {
    widgets.WidgetsFlutterBinding.ensureInitialized();
  }

  widgets.Rect player = widgets.Rect.fromLTWH(10, 10, 20, 20);
  widgets.Paint playerPaint = widgets.Paint()..color = widgets.Color(0xFFFFFFFF);

  factory LuaFlame.forPlatform(String program) {
    switch (Platform.operatingSystem) {
      case 'linux':
        return LinuxLuaFlame(program);
      default:
        throw Exception(
          'Oops! Unimplemented operating system ${Platform.operatingSystem}',
        );
    }
  }

  void render(widgets.Canvas c) {
    c.drawRect(player, playerPaint);
  }

  void update(double t);
}

/*
class SampleLuaFlame implements LuaFlame {
  final MethodChannel _channel = const MethodChannel('lua_flame');

  Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
*/

final ffi.DynamicLibrary dynamicLibrary = ffi.DynamicLibrary.open(
  'liblua_flame_plugin.so',
);

final bindings.NativeLibrary lib = bindings.NativeLibrary(
  dynamicLibrary,
);

void checkOk(int ok) {
  if (ok != bindings.LUA_OK) {
    throw Exception('Oops! ok was $ok, wanted ${bindings.LUA_OK}');
  }
}
