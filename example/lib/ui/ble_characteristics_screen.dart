import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';


class CharacteristicsScreen extends StatefulWidget {
  final BleDevice _connectedDevice;
  final List<Characteristic> _characteristics;

  CharacteristicsScreen(this._connectedDevice, this._characteristics);

  @override
  State<StatefulWidget> createState() {
    return new CharacteristicsScreenState(_connectedDevice, _characteristics);
  }
}

class CharacteristicsScreenState extends State<StatefulWidget> {
  final BleDevice _connectedDevice;
  final List<Characteristic> _characteristics;

  CharacteristicsScreenState(this._connectedDevice, this._characteristics);

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
            "${_connectedDevice.name ?? "Unkonwn"} device services."),
      ),
      body: new CharacteristicList(_connectedDevice, _characteristics, context),
    );
  }
}

class CharacteristicList extends StatefulWidget {


  final BleDevice _connectedDevice;

  final List<Characteristic> _characteristic;

  final BuildContext _mainBuildContext;

  CharacteristicList(this._connectedDevice, this._characteristic, this._mainBuildContext);

  @override
  State<StatefulWidget> createState() =>
      new CharacteristicListState(
          _connectedDevice, _characteristic, _mainBuildContext);
}

class CharacteristicListState extends State<StatefulWidget> {

  final BleDevice _connectedDevice;

  final List<Characteristic> _characteristic;

  final BuildContext _mainBuildContext;

  CharacteristicListState(this._connectedDevice, this._characteristic,
      this._mainBuildContext);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _characteristic == null ? 0 : _characteristic.length,
        itemBuilder: (BuildContext context, int index) =>
            buildItem(_characteristic[ index], _mainBuildContext)
    );
  }


  Card buildItem(Characteristic characteristic, BuildContext context) {
    return new Card(
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Service : ",
              style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text("ID :  ${characteristic.id}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("UUID :  ${characteristic.uuid}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Service id :  ${characteristic.serviceId}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Service Uuid :  ${characteristic.serviceUuid}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Device id :  ${characteristic.deviceId}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is readable :  ${characteristic.isReadable}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is writable with response :  ${characteristic.isWritableWithResponse}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is writable without response : ${characteristic.isWritableWithoutResponse}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is notificable : ${characteristic.isNotificable}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is indicatable :  ${characteristic.isIndicatable0}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is notifing : ${characteristic.isNotifing}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Value : ${characteristic.value}",
              style: new TextStyle(fontSize: 12.0),),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed: (){},
                  color: Colors.blueAccent,
                  child: new Text(
                    "Characterisitic for Device",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
            ),
            new Container (
              margin: const EdgeInsets.only(bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed:  (){},
                  color: Colors.blueAccent,
                  child: new Text(
                    "Characterisitic for Service",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  _onCharacteristicForDeviceClick(String macAddress, String serviceUUID) {
    FlutterBleLib.instance
        .characteristicsForDevice(macAddress, serviceUUID)
        .then((characteristics) {
      print(characteristics);
    });
  }

  _onCharacteristicForServiceClick(int serviceIdentifier) {
    FlutterBleLib.instance
        .characteristicsForService(serviceIdentifier)
        .then((characteristics) {
      print(characteristics);
    });
  }
}