import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:uuid/uuid.dart';


class BleConnectedDeviceScreen extends StatefulWidget {
  final BleDevice _connectedDevice;

  BleConnectedDeviceScreen(this._connectedDevice);

  @override
  State<StatefulWidget> createState() {
    return new BleConnectedDeviceScreenState(_connectedDevice);
  }
}

class BleConnectedDeviceScreenState extends State<StatefulWidget> {
  final BleDevice _connectedDevice;
  String _serviceDiscoveringState = "Unknown";

  BleConnectedDeviceScreenState(this._connectedDevice);

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.onDeviceConnectionChanged()
        .listen((device) =>
        setState(() =>
        _connectedDevice.isConnected = device.isConnected
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "${_connectedDevice.name ?? "Unkonwn"} device info."),
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
              new Text("MTU : + ${_connectedDevice.mtu}",
                style: new TextStyle(fontSize: 14.0),),
              new Text("BleDevice connected device: ",
                style: new TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.bold,),),
              new Text("\tname : ${_connectedDevice.name}",
                style: new TextStyle(fontSize: 12.0),),
              new Text(
                "\tmac address : ${_connectedDevice.macAddress}",
                style: new TextStyle(fontSize: 12.0),),
              new Text(
                "\tis connected : ${_connectedDevice.isConnected}",
                style: new TextStyle(fontSize: 12.0),),
              new Text(
                "\tstate of service discovering : $_serviceDiscoveringState",
                style: new TextStyle(fontSize: 12.0),),
              new Container (
                margin: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new MaterialButton(
                      onPressed: () => _onIsConnectedButtonClick(),
                      color: Colors.blueAccent,
                      child: new Text(
                        "Is connected?",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(left: 18.0,),
                      child: new MaterialButton(
                        onPressed: () => _onCancelDeviceConnection(context),
                        color: Colors.blueAccent,
                        child: new Text(
                          "Canncel connection",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Center(
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Text(
                      "Device action buttons",
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0, top: 18.0,),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed: _onRequestMtuButtonClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Request Mtu",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed: _onReadRSSIForDeviceClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Read RSSI",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed:  _onDiscoverAllServicesClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Discover all services",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed: _onServicesForDeviceClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Services for device",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed: _onCharacteristicForDeviceClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Characteristic for device",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new MaterialButton(
                        minWidth: 400.0,
                        onPressed: _onCharacteristicForServiceClick,
                        color: Colors.blueAccent,
                        child: new Text(
                          "Characteristic for service",
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onDiscoverAllServicesClick() {
    FlutterBleLib.instance.discoverAllServicesAndCharacteristicsForDevice(
        _connectedDevice.macAddress)
        .then((device) {
      setState(() {
        _serviceDiscoveringState = "DONE";
      });
    });
  }

  _onCancelDeviceConnection(BuildContext context) {
    FlutterBleLib.instance.cancelDeviceConnection(_connectedDevice.macAddress)
        .then((device) {
      print("Connection ${device.macAddress} canceld");
      Navigator.of(context).pop();
    }
    );
  }

  _onReadRSSIForDeviceClick() {
    FlutterBleLib.instance.readRSSIForDevice(
        _connectedDevice.macAddress, new Uuid().v1())
        .then((device) {
      setState(() {
        _connectedDevice.rssi = device.rssi;
      });
    });
  }

  _onRequestMtuButtonClick() {
    FlutterBleLib.instance.requestMTUForDevice(
        _connectedDevice.macAddress, _connectedDevice.mtu, new Uuid().v1())
        .then((device) {
      setState(() {
        _connectedDevice.mtu = device.mtu;
      });
    });
  }

  _onIsConnectedButtonClick() {
    FlutterBleLib.instance
        .isDeviceConnected(_connectedDevice.macAddress)
        .then(
            (isConnected) {
          setState(() {
            _connectedDevice.isConnected = isConnected;
          });
        }
    );
  }

  _onServicesForDeviceClick() {
    FlutterBleLib.instance
        .servicesForDevice(_connectedDevice.macAddress)
        .then((services) {
      print(services);
    });
  }


  _onCharacteristicForDeviceClick() {
    FlutterBleLib.instance
        .characteristicsForDevice(_connectedDevice.macAddress, "00001800-0000-1000-8000-00805f9b34fb")
        .then((characteristics) {
      print(characteristics);
    });
  }


  _onCharacteristicForServiceClick() {
    FlutterBleLib.instance
        .characteristicsForService(1)
        .then((characteristics) {
      print(characteristics);
    });
  }
}