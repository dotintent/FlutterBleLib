import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BleManager bleManager = BleManager();
  String devices = "";

  @override
  void initState() {
    super.initState();
    initBleManager();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initBleManager() {

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    bleManager.createClient("5", (devices) {
      setState(() {
        if (!mounted) return;
        this.devices = devices.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Devices: $devices'),
        ),
      ),
    );
  }
}
