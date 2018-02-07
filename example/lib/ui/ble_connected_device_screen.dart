import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/ui/button_widget.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/ble_services_screen.dart';
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
          child: new ListView(
            children: <Widget>[
              new Text(
                "Connected device : ",
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _label("RSSI : ${_connectedDevice.rssi}"),
              _label("MTU : ${_connectedDevice.mtu}"),
              new Text("BleDevice connected device: ",
                style: new TextStyle(
                  fontSize: 14.0, fontWeight: FontWeight.bold,),),
              _smallLabel("\tname : ${_connectedDevice.name}"),
              _smallLabel("\tmac address : ${_connectedDevice.id}"),
              _smallLabel("\tis connected : ${_connectedDevice.isConnected}"),
              _smallLabel("\tstate of service discovering : $_serviceDiscoveringState"),
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
                      margin: const EdgeInsets.only(left: 18.0),
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
                    new Container (
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: new Text(
                        "Device action buttons",
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _button("Request Mtu", _onRequestMtuButtonClick),
                    _button("Read RSSI", _onReadRSSIForDeviceClick),
                    _button("Discover all services", _onDiscoverAllServicesClick),
                    _button("Services for device", _serviceDiscoveringState !="DONE" ? null :() => _onServicesForDeviceClick(context))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _label(String text) =>
      new Text(text, style: new TextStyle(fontSize: 14.0),);

  _smallLabel(String text) =>
    new Text(text, style: new TextStyle(fontSize: 12.0),);

  _button(String text, VoidCallback onPressed) =>
      new Container (
        margin: const EdgeInsets.only(bottom: 10.0),
        child: new CustomMaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          disabledColor: Colors.grey,
          child: new Text(
            text,
            style: new TextStyle(color: Colors.white),
          ),
        ),
      );

  _onDiscoverAllServicesClick() {
    FlutterBleLib.instance.discoverAllServicesAndCharacteristicsForDevice(
        _connectedDevice.id)
        .then((device) {
      setState(() {
        _serviceDiscoveringState = "DONE";
      });
    });
  }

  _onCancelDeviceConnection(BuildContext context) {
    FlutterBleLib.instance.cancelDeviceConnection(_connectedDevice.id)
        .then((device) {
      print("Connection ${device.id} canceld");
      Navigator.of(context).pop();
    }
    );
  }

  _onReadRSSIForDeviceClick() {
    FlutterBleLib.instance.readRSSIForDevice(
        _connectedDevice.id, new Uuid().v1())
        .then((device) {
      setState(() {
        _connectedDevice.rssi = device.rssi;
      });
    });
  }

  _onRequestMtuButtonClick() {
    FlutterBleLib.instance.requestMTUForDevice(
        _connectedDevice.id, _connectedDevice.mtu, new Uuid().v1())
        .then((device) {
      setState(() {
        _connectedDevice.mtu = device.mtu;
      });
    });
  }

  _onIsConnectedButtonClick() {
    FlutterBleLib.instance
        .isDeviceConnected(_connectedDevice.id)
        .then(
            (isConnected) {
          setState(() {
            _connectedDevice.isConnected = isConnected;
          });
        }
    );
  }

  _onServicesForDeviceClick(BuildContext context) {
    FlutterBleLib.instance
        .servicesForDevice(_connectedDevice.id)
        .then((services) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext buildContext) =>
          new BleServicesScreen(_connectedDevice, services)));
    });
  }
}