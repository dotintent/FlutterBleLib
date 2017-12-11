import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/ble_connected_device_screen.dart';

class BleScanResultList extends StatelessWidget {

  final List<ScanResult> _scanResults;

  final BuildContext _mainBuildContext;

  BleScanResultList(this._scanResults, this._mainBuildContext);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _scanResults == null ? 0 : _scanResults.length,
        itemBuilder: (BuildContext context, int index) =>
            buildItem(_scanResults[ index], _mainBuildContext)
    );
  }

  Card buildItem(ScanResult scanResults, BuildContext context) {
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
                  onPressed: () => _onConnectButtonClick(scanResults),
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

  _onConnectButtonClick(ScanResult scanResults) {
    FlutterBleLib.instance.connectToDevice(
        scanResults.bleDevice.macAddress, isAutoConnect: true).then((
        connectedDevice) {
      Navigator.of(_mainBuildContext).push(new MaterialPageRoute(
          builder: (BuildContext buildContext) =>
          new BleConnectedDeviceScreen(connectedDevice)));
    }
    );
  }
}

class BleDevicesScreen extends StatefulWidget {
  @override
  BleDevicesState createState() => new BleDevicesState();
}

class BleDevicesState extends State<BleDevicesScreen> {

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
    FlutterBleLib.instance.destroyClient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter Ble Library Example - Scan List'),
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(_isScan ? Icons.close : Icons.bluetooth),
          onPressed: _isScan ? _onStopScan : _onStartScan,
        ),
        body: new Stack(
          children: <Widget>[
            new BleScanResultList(_scanResults, context),
          ],
        ),
      ),
    );
  }


  _onStopScan() {
    _scanDevicesSub?.cancel();
    _scanDevicesSub = null;
    FlutterBleLib.instance.stopDeviceScan();
    setState(() {
      _isScan = false;
    });
  }

  _onStartScan() {
    _scanDevicesSub = FlutterBleLib.instance
        .startDeviceScan(1, 1)
        .listen((scanResult) {
      setState
        (() {
        _addOrUpdateIfNecessary(scanResult);
      });
    }, onDone: _onStopScan);

    setState(() {
      _isScan = true;
    });
  }

  _addOrUpdateIfNecessary(ScanResult scanResultItem) {
    for (var scanResult in _scanResults) {
      if (scanResult.hasTheSameDeviceAs(scanResultItem)) {
        scanResult.update(scanResultItem);
        return;
      }
    }
    _scanResults.add(scanResultItem);
  }
}