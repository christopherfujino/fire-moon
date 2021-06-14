import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/lua.dart';
import 'package:ide/store/store.dart';
import 'package:slices/slices.dart';

class CodeEditor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CodeEditorState();
  }
}

class _CodeEditorState extends State<CodeEditor> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      language: lua,
      theme: monokaiSublimeTheme,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO Make a SliceListener as there is no need for builder here
    return SliceWatcher<IDEState, String>(
        slicer: (state) => state.code,
        shouldRebuild: (oldSlice, newSlice) => false,
        listener: (state, event) {
          if (event is RequestGameCodeAndRun) {
            SlicesProvider.of<IDEState>(context).dispatch(
                RunGameCode(_codeController.rawText),
            );
          }
        },
        builder: (context, slice, store) {
          return CodeField(
              controller: _codeController,
              textStyle: TextStyle(fontFamily: 'SourceCode'),
          );
        },
    );
  }
}
