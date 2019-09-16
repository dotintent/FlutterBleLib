import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BleManager bleManager = BleManager.getInstance();
  String preview = "";
  String deviceName = "";
  String latestScan = "";
  bool deviceConnectionAttempted = false;
  PeripheralConnectionState connectionState = null;

  @override
  void initState() {
    super.initState();
    initBleManager();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBleManager() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    await bleManager.createClient(
        restoreStateIdentifier: "5",
        restoreStateAction: (devices) {
          setState(() {
            if (!mounted) return;
            this.preview = devices.toString();
          });
        });
  }

  void test() {
    bleManager.startDeviceScan().listen((scanResult) async {
      setState(() {
        latestScan = scanResult.peripheral.identifier;
      });

      if (scanResult?.peripheral != null &&
          scanResult.peripheral.name == "SensorTag" &&
          !deviceConnectionAttempted) {
        deviceConnectionAttempted = true;
        await bleManager.stopDeviceScan();
        tryToConnect(scanResult.peripheral);
      }
    }, onError: (error) {
      print(error);
    });
  }

  Future<void> tryToConnect(Peripheral peripheral) async {
    setState(() {
      deviceName = peripheral.name;
    });
    await peripheral.connect();
    peripheral.observeConnectionState(emitCurrentValue: true).listen((connectionState) {
      setState(() {
        this.connectionState = connectionState;
      });
    });

    setState(() {
      deviceConnectionAttempted = false;
    });

//    await peripheral.disconnectOrCancelConnection();

//    Future.delayed(Duration(milliseconds: 3000))
//        .then((value) => bleManager.destroyClient())
//        .then((value) => setState(() {
//      preview = preview + "\nBleClient destroyed after a delay";
//    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Restored devices: $preview'),
                Text('Last scanned device: $latestScan'),
                Text('Current device: $deviceName'),
                Text('Connection state: $connectionState')
              ],
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("TEST"),
                  onPressed: this.test,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
