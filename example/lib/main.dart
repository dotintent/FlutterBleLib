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
  String info = "";
  String deviceName = "";
  String latestScan = "";
  bool deviceConnectionAttempted = false;
  PeripheralConnectionState connectionState;

  @override
  void initState() {
    super.initState();
  }

  void test() async {
    await bleManager.createClient(
        restoreStateIdentifier: "5",
        restoreStateAction: (devices) {
          setState(() {
            if (!mounted) return;
            this.preview = devices.toString();
          });
        });

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
    peripheral
        .observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      setState(() {
        this.connectionState = connectionState;
        if (connectionState == PeripheralConnectionState.disconnected) {
          deviceName = null;
        }
      });
    });

    setState(() {
      deviceConnectionAttempted = false;
    });

    Future.delayed(Duration(seconds: 10))
        .then((_) => peripheral.disconnectOrCancelConnection())
        .then((_) => Future.delayed(Duration(seconds: 10))
        .then((_) => bleManager.destroyClient())
        .then((_) => setState(() {
              info = "\BleClient destroyed after a delay";
            }));
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
                Text('$info'),
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
