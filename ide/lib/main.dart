import 'package:flutter/material.dart';
import 'package:ide/app/app.dart';
import 'package:ide/store/store.dart';
import 'package:slices/slices.dart';

void main() {
  final store = SlicesStore<IDEState>(IDEState(code: ''));
  runApp(FireMoonIDE(store: store));
}
