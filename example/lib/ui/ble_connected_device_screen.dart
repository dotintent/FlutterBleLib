import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';


class BleConnectedDeviceScreen extends StatefulWidget {
  final ConnectedDevice _connectedDevice;

  BleConnectedDeviceScreen(this._connectedDevice);

  @override
  State<StatefulWidget> createState() {
    return new BleConnectedDeviceScreenState(_connectedDevice);
  }
}

class BleConnectedDeviceScreenState extends State<StatefulWidget> {
  final ConnectedDevice _connectedDevice;

  BleConnectedDeviceScreenState(this._connectedDevice);

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.onDeviceConnectionChanged()
        .listen((device) =>
        setState(() =>
        _connectedDevice.bleDevice.isConnected = device.isConnected
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "${_connectedDevice.bleDevice.name ?? "Unkonwn"} device info."),
      ),
      body: new Container(
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Connected device : ",
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text("RSSI : + ${_connectedDevice.rssi}",
                style: new TextStyle(fontSize: 14.0),),
              new Text("RSSI : + ${_connectedDevice.mtu}",
                style: new TextStyle(fontSize: 14.0),),
              new Text("BleDevice connected device: ",
                style: new TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.bold,),),
              new Text("\tname : ${_connectedDevice.bleDevice.name}",
                style: new TextStyle(fontSize: 12.0),),
              new Text(
                "\tmac address : ${_connectedDevice.bleDevice.macAddress}",
                style: new TextStyle(fontSize: 12.0),),
              new Text(
                "\tis connected : ${_connectedDevice.bleDevice.isConnected}",
                style: new TextStyle(fontSize: 12.0),),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new MaterialButton(
                    onPressed: () => _onIsConnectedButtonClick(),
                    color: Colors.blueAccent,
                    child: new Text(
                      "IS CONNECTED",
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _onIsConnectedButtonClick() {
    FlutterBleLib.instance
        .isDeviceConnected(_connectedDevice.bleDevice.macAddress)
        .then(
            (isConnected) {
          setState(() {
            _connectedDevice.bleDevice.isConnected = isConnected;
          });
        }
    );
  }
}