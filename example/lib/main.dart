import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/ui/ble_start_screen.dart';
import 'package:flutter_ble_lib_example/ui/ble_devieces_screen.dart';
import 'package:flutter_ble_lib_example/ui/screen_names.dart' as ScreenNames;


void main() {
  runApp(new MaterialApp(
    home: new BleStartScreen(),
    routes: <String, WidgetBuilder>{
      ScreenNames.bleStartScreen: (
          BuildContext context) => new BleStartScreen(),
      ScreenNames.bleDevicesScreen: (
          BuildContext context) => new BleDevicesScreen(),
    },
  ));
}


