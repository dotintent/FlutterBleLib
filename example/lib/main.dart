import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class BleScanResultList extends StatelessWidget {

  final List<ScanResult> _scanResults;

  BleScanResultList(this._scanResults);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _scanResults == null ? 0 : _scanResults.length,
        itemBuilder: (BuildContext context, int index) =>
            buildItem(_scanResults[ index])
    );
  }

  Card buildItem(ScanResult scanResults) {
    return new Card(
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Scan Result : ",
              style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text("RSSI : + ${scanResults.rssi}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Timestamp nanos : + ${scanResults.timestampNanos}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Scan callback type : + ${scanResults.scanCallbackType}",
              style: new TextStyle(fontSize: 12.0),),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text("BleDevice : ",
                      style: new TextStyle(
                        fontSize: 12.0, fontWeight: FontWeight.bold,),),
                    new Text("\tname : ${scanResults.bleDevice.name}",
                      style: new TextStyle(fontSize: 10.0),),
                    new Text(
                      "\tmac address : ${scanResults.bleDevice.macAddress}",
                      style: new TextStyle(fontSize: 10.0),),
                  ],
                ),
                new MaterialButton(
                  onPressed: () => print("it is not implemented yet!!!"),
                  color: Colors.blueAccent,
                  child: new Text(
                    "CONNECT", style: new TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends State<MyApp> {

  StreamSubscription _scanDevicesSub;

  bool _isScan = false;
  final List<ScanResult> _scanResults = new List();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    _onStopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(_isScan ? Icons.close : Icons.bluetooth),
          onPressed: _isScan ? _onStopScan : _onStartScan,
        ),
        body: new Stack(
          children: <Widget>[
            new BleScanResultList(_scanResults),
          ],
        ),
      ),
    );
  }

  _onStopScan() {
    _scanDevicesSub?.cancel();
    _scanDevicesSub = null;
    FlutterBleLib.instance.stopScan();
    setState(() {
      _isScan = false;
    });
  }

  _onStartScan() {
    _scanDevicesSub = FlutterBleLib.instance
        .scan(scanMode: 1, callbackType: 1)
        .listen((scanResult) {
      setState
        (() {
        if (!_contains(scanResult))
          _scanResults.add(scanResult);
      });
    }, onDone: _onStopScan);

    setState(() {
      _isScan = true;
    });
  }

  bool _contains(ScanResult scanResultItem) {
    for (var scanResult in _scanResults) {
      if (scanResult.hasTheSameDeviceAs(scanResultItem)) {
        return true;
      }
    }
    return false;
  }
}
