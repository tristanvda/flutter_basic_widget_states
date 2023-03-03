import 'package:flutter/material.dart';
import 'package:flutter_basic_widget_states/states_example.dart';

void main() {
  runApp(const StatesExampleApp());
}

class StatesExampleApp extends StatelessWidget {
  const StatesExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget states demo',
      theme: ThemeData(
        cardTheme: const CardTheme(
          elevation: 4.0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))
          )
        ),
        primarySwatch: Colors.blue,
      ),
      home: const StatesExamplePage(),
    );
  }
}