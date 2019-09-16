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
  String preview = "";

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

    bleManager.createClient(
        restoreStateIdentifier: "5",
        restoreStateAction: (devices) {
          setState(() {
            if (!mounted) return;
            this.preview = devices.toString();
          });
        });

    Future.delayed(Duration(milliseconds: 3000))
        .then((value) => bleManager.destroyClient())
        .then((value) => setState(() {
              preview = preview + "\nBleClient destroyed after a delay";
            }));
    bleManager.startDeviceScan().listen((scanResult) {
      print(scanResult);
    }, onError: (error) {
      print(error);
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
          child: Text('Devices: $preview'),
        ),
      ),
    );
  }
}
