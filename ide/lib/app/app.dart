import 'package:flutter/material.dart';
import 'package:ide/app/code_editor.dart';
import 'package:ide/app/game_preview.dart';
import 'package:ide/app/toolbar.dart';
import 'package:ide/store/store.dart';
import 'package:slices/slices.dart';

class FireMoonIDE extends StatelessWidget {
  final SlicesStore<IDEState> store;

  FireMoonIDE({required this.store});

  @override
  Widget build(BuildContext context) {
    return SlicesProvider(
      store: store,
      child: MaterialApp(
        title: 'Fire Moon IDE',
        home: Scaffold(
          body: _AppBody(),
        ),
      ),
    );
  }
}

class _AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Toolbar(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 6, child: CodeEditor()),
              Expanded(flex: 4, child: GamePreview()),
            ],
          ),
        ),
      ],
    );
  }
}
