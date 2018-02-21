import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/ui/ble_devieces_screen.dart';
import 'package:flutter_ble_lib_example/ui/screen_on_boarding.dart';
import 'package:flutter_ble_lib_example/ui/screen_names.dart' as ScreenNames;

const Color polideaColor =  const Color.fromRGBO(25, 159, 217, 1.0);
void main() {
  runApp(new MaterialApp(
    home: new OnBoardingPager(),
    theme: new ThemeData(
      canvasColor: polideaColor,
      iconTheme: new IconThemeData(color: Colors.white),
      accentColor: Colors.pinkAccent,
      brightness: Brightness.dark,
    ),
    routes: <String, WidgetBuilder>{
      ScreenNames.bleDevicesScreen: (
          BuildContext context) => new BleDevicesScreen(),
    },
  ));
}


