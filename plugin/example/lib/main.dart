import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/widgets.dart' as widgets;
import 'package:lua_flame/lua_flame.dart' as Plugin;

final String program = """
max_x = 500
min_x = 10

function onLoad()
  component_0_x = 50
  component_0_y = 5
  print('Lua app initialized!')
end

function update()
  component_0_x = component_0_x + 1
  if component_0_x > max_x then
    component_0_x = min_x
  end
end
""";

void main() async {
  final Plugin.LuaFlame game = Plugin.LuaFlame(program);
  widgets.runApp(GameWidget(game: game));
}
