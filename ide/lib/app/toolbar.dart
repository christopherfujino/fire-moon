import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ide/store/store.dart';
import 'package:slices/slices.dart';

class _ToolbarSlice extends Equatable {
  final bool running;

  _ToolbarSlice.fromState(IDEState state) : this.running = state.running;

  @override
  List<Object?> get props => [running];
}

class Toolbar extends StatelessWidget {
  void _runGame(SlicesStore<IDEState> store) {
    store.event(RequestGameCodeAndRun());
  }

  void _stopGame(SlicesStore<IDEState> store) {
    store.dispatch(StopGameAction());
  }

  @override
  Widget build(BuildContext context) {
    return SliceWatcher<IDEState, _ToolbarSlice>(
      slicer: (state) => _ToolbarSlice.fromState(state),
      builder: (context, store, slice) {
        return Container(
          padding: EdgeInsets.only(left: 20),
          height: 50,
          child: Row(
            children: [
              if (slice.running) ...[
                GestureDetector(
                  child: Icon(Icons.refresh),
                  onTap: () => _runGame(store),
                ),
                GestureDetector(
                  child: Icon(Icons.stop),
                  onTap: () => _stopGame(store),
                ),
              ],
              if (!slice.running)
                GestureDetector(
                  child: Icon(Icons.play_arrow),
                  onTap: () => _runGame(store),
                ),
            ],
          ),
        );
      },
    );
  }
}
