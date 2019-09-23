import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_ble_lib_example/test_scenario_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: TestScenarioWidget(),
      ),
    );
  }
}
