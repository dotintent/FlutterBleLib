import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/ble_connected_device_screen.dart';


class BleScanResultList extends StatefulWidget {

  final List<ScanResult> _scanResults;

  final BuildContext _mainBuildContext;

  BleScanResultList(this._scanResults, this._mainBuildContext);

  @override
  State<StatefulWidget> createState() =>
      new BleScanResultListState(_scanResults, _mainBuildContext);
}

class BleScanResultListState extends State<StatefulWidget> {

  final List<ScanResult> _scanResults;

  final BuildContext _mainBuildContext;

  BleScanResultListState(this._scanResults, this._mainBuildContext);

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
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("BleDevice : ",
                  style: new TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold,),),
                new Text("\tname : ${scanResults.bleDevice.name}",
                  style: new TextStyle(fontSize: 10.0),),
                new Text(
                  "\tmac address : ${scanResults.bleDevice.id}",
                  style: new TextStyle(fontSize: 10.0),),
                new Text(
                  "\tis connected : ${scanResults.bleDevice.isConnected}",
                  style: new TextStyle(fontSize: 10.0),),
              ],
            ),
            new Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Container (
                    margin: const EdgeInsets.only(right: 12.0),
                    child: new MaterialButton(
                      onPressed: () => _onIsConnectedButtonClick(scanResults),
                      color: Colors.blueAccent,
                      child: new Text(
                        "IS CONNECTED",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  _onConnectButtonClick(ScanResult scanResults) {
    FlutterBleLib.instance.connectToDevice(
        scanResults.bleDevice.id, isAutoConnect: true).then((
        connectedDevice) {
      Navigator.of(_mainBuildContext).push(new MaterialPageRoute(
          builder: (BuildContext buildContext) =>
          new BleConnectedDeviceScreen(connectedDevice)));
    }
    );
  }

  _onIsConnectedButtonClick(ScanResult scanResult) =>
      FlutterBleLib.instance
          .isDeviceConnected(scanResult.bleDevice.id)
          .then((isConnected) =>
          setState(() => scanResult.bleDevice.isConnected = isConnected));
}

class BleDevicesScreen extends StatefulWidget {
  @override
  BleDevicesState createState() => new BleDevicesState();
}

class BleDevicesState extends State<BleDevicesScreen> {

  StreamSubscription _scanDevicesSub;
  StreamSubscription _bluetoothStateSub;

  bool _isScan = false;
  BluetoothState bluetoothState = null;
  final List<ScanResult> _scanResults = new List();

  @override
  initState() {
    super.initState();
    _bluetoothStateSub = FlutterBleLib.instance.onStateChange()
        .listen((bluetoothState) =>
        setState(() => this.bluetoothState = bluetoothState));
  }

  @override
  dispose() {
    _onStopScan();
    _cancelStateChange();
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
        bottomNavigationBar: new Text(
          "Current state : ${bluetoothState ?? "null"}",
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),
        ),
        body: new Stack(
          children: <Widget>[
            new BleScanResultList(_scanResults, context),
          ],
        ),
      ),
    );
  }

  _cancelStateChange() {
    _bluetoothStateSub?.cancel();
    _bluetoothStateSub = null;
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
        .listen(
            (scanResult) => setState(() => _addOrUpdateIfNecessary(scanResult)),
        onDone: _onStopScan);

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