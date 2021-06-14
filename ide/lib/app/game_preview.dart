import 'package:equatable/equatable.dart';
import 'package:slices/slices.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ide/store/store.dart';
import 'package:lua_flame/lua_flame.dart';

class _GamePreviewSlice extends Equatable {
  final bool running;
  final String code;

  _GamePreviewSlice.fromState(IDEState state)
      : this.running = state.running,
        this.code = state.code;

  @override
  List<Object?> get props => [running, code];
}

class GamePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliceWatcher<IDEState, _GamePreviewSlice>(
        slicer: (state) => _GamePreviewSlice.fromState(state),
        builder: (context, store, slice) {
          if (slice.running) {
            final game = LuaFlame(slice.code);
            return GameWidget(game: game);
          } else {
            return Container();
          }
        },
    );
  }
}
