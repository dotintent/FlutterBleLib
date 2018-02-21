import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/ble_services_screen.dart';
import 'package:flutter_ble_lib_example/ui/button_widget.dart';
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
    final TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .title;
    final TextStyle body1Style = Theme
        .of(context)
        .textTheme
        .body1;
    final TextStyle body2Style = Theme
        .of(context)
        .textTheme
        .body2;
    final TextStyle buttonStyle = Theme
        .of(context)
        .textTheme
        .button;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text(
            "${_connectedDevice.name ?? "Unkonwn"} device info."),
      ),
      body: new Card(
        color: const Color.fromRGBO(69, 90, 100, 1.0),
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          child: new ListView(
            children: <Widget>[
              new Text("Connected device : ", style: titleStyle,),
              new Text(_label(), style: body1Style),
              new Text(_smallLabel(), style: body2Style,),
              new Container (
                margin: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new MaterialButton(
                      onPressed: () => _onIsConnectedButtonClick(),
                      color: Colors.blueAccent,
                      child: new Text("Is connected?", style: buttonStyle,),
                    ),
                    new Container (
                      margin: const EdgeInsets.only(left: 18.0),
                      child: new MaterialButton(
                        onPressed: () => _onCancelDeviceConnection(context),
                        color: Colors.blueAccent,
                        child: new Text(
                          "Canncel connection", style: buttonStyle,),
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
                        "Device action buttons", style: titleStyle,),
                    ),
                    _button(
                        "Request Mtu", _onRequestMtuButtonClick, buttonStyle),
                    _button(
                        "Read RSSI", _onReadRSSIForDeviceClick, buttonStyle),
                    _button(
                        "Discover all services", _onDiscoverAllServicesClick,
                        buttonStyle),
                    _button("Services for device",
                        _serviceDiscoveringState != "DONE" ? null : () =>
                            _onServicesForDeviceClick(context), buttonStyle)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _label() => "RSSI : ${_connectedDevice.rssi}\nMTU : ${_connectedDevice.mtu}\nBleDevice connected device :";

  _smallLabel() =>
      "\tname : ${_connectedDevice.name}\n\tid : ${_connectedDevice
          .id}\n\tis connected : ${_connectedDevice
          .isConnected}\n\tstate of service discovering : $_serviceDiscoveringState";

  _button(String text, VoidCallback onPressed, TextStyle buttonStyle) =>
      new Container (
        margin: const EdgeInsets.only(bottom: 10.0),
        child: new CustomMaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          disabledColor: Colors.grey,
          child: new Text(text, style: buttonStyle),
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