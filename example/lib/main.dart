import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_ble_lib_example/test_scenario_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

abstract class SensorTagTemperatureUuids {
  static const String temperatureService =
      "F000AA00-0451-4000-B000-000000000000";
  static const String temperatureData = "F000AA01-0451-4000-B000-000000000000";
  static const String temperatureConfig =
      "F000AA02-0451-4000-B000-000000000000";
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
