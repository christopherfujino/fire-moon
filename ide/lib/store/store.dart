import 'package:slices/slices.dart';

class IDEState extends SlicesState {
  final String code;
  final bool running;

  IDEState({
    required this.code,
    this.running = false,
  });

  IDEState copyWith({
    String? code,
    bool? running,
  }) {
    return IDEState(
        code:  code ?? this.code,
        running: running ?? this.running,
    );
  }
}

class StopGameAction extends SlicesAction<IDEState> {
  @override
  IDEState perform(SlicesStore<IDEState> store, IDEState state) {
    return state.copyWith(running: false);
  }
}

class RunGameCode extends SlicesAction<IDEState> {
  final String code;

  RunGameCode(this.code);

  @override
  IDEState perform(SlicesStore<IDEState> store, IDEState state) {
    return state.copyWith(code: code, running: true);
  }
}

class RequestGameCodeAndRun extends SlicesEvent<IDEState> {}
