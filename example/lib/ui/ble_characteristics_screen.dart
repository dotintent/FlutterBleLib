import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:uuid/uuid.dart';


class CharacteristicsScreen extends StatefulWidget {
  final BleService _bleService;
  final List<Characteristic> _characteristics;

  CharacteristicsScreen(this._bleService, this._characteristics);

  @override
  State<StatefulWidget> createState() {
    return new CharacteristicsScreenState(_bleService, _characteristics);
  }
}

class CharacteristicsScreenState extends State<StatefulWidget> {
  final BleService _bleService;
  final List<Characteristic> _characteristics;

  CharacteristicsScreenState(this._bleService, this._characteristics);

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.onDeviceConnectionChanged()
        .listen((device) =>
        setState(() =>
        _bleService.device.isConnected = device.isConnected
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            "${_bleService.device.name ?? "Unkonwn"} device services."),
      ),
      body: new CharacteristicList(_bleService, _characteristics, context),
    );
  }
}

class CharacteristicList extends StatefulWidget {


  final BleService _bleService;

  final List<Characteristic> _characteristic;

  final BuildContext _mainBuildContext;

  CharacteristicList(this._bleService, this._characteristic, this._mainBuildContext);

  @override
  State<StatefulWidget> createState() =>
      new CharacteristicListState(
          _bleService, _characteristic, _mainBuildContext);
}

class CharacteristicListState extends State<StatefulWidget> {

  final BleService _bleService;

  final List<Characteristic> _characteristic;

  final BuildContext _mainBuildContext;

  CharacteristicListState(this._bleService, this._characteristic,
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
            new Text("Is indicatable :  ${characteristic.isIndicatable}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is notifing : ${characteristic.isNotifing}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Value : ${characteristic.value}",
              style: new TextStyle(fontSize: 12.0),),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                    ? () =>_onWriteCharacteristic(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Write characteristic",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                    ? () =>_onWriteCharacteristicForService(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Write characteristic for service",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                    ? () =>_onWriteCharacteristicForDevice(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Write characteristic for device",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed: characteristic.isReadable ? () =>_onReadCharacteristic(characteristic) : null,
                  color: Colors.blueAccent,
                  child: new Text(
                    "Read characteristic",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed: characteristic.isReadable ? () =>_onReadCharacteristicForDevice(characteristic) : null,
                  color: Colors.blueAccent,
                  child: new Text(
                    "Read characteristic for device",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed: characteristic.isReadable ? () =>_onReadCharacteristicForService(characteristic) : null,
                  color: Colors.blueAccent,
                  child: new Text(
                    "Read characteristic for service",
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isNotificable ? () =>_onMonitorCharacteristicForDevice(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Monitor characterisitic for device",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isNotificable ? () =>_onMonitorCharacteristicForService(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Monitor characterisitic for service",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),

            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                minWidth: 400.0,
                onPressed: characteristic.isNotificable ? () =>_onMonitorCharacteristic(characteristic) : null,
                color: Colors.blueAccent,
                child: new Text(
                  "Monitor characterisitic",
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onWriteCharacteristic(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristic(
        characteristic.id,
        "???",
        characteristic.isWritableWithResponse,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onWriteCharacteristicForService(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristicForService(
        _bleService.id,
        characteristic.uuid,
        "???",
        characteristic.isWritableWithResponse,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onWriteCharacteristicForDevice(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristicForDevice(
        _bleService.device.macAddress,
        _bleService.uuid,
        characteristic.uuid,
        "???",
        characteristic.isWritableWithResponse,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onReadCharacteristic(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristic(
        characteristic.id, new Uuid().v1())
        .then((value) => print(value));
  }

  _onReadCharacteristicForDevice(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristicForDevice(
        _bleService.device.macAddress, _bleService.uuid, characteristic.uuid,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onReadCharacteristicForService(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristicForService(
        _bleService.id, characteristic.uuid,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onMonitorCharacteristicForDevice(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForDevice(
        _bleService.device.macAddress,
        _bleService.uuid,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => print(value))
    ;
  }

  _onMonitorCharacteristicForService(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForService(
        _bleService.id,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => print(value))
    ;
  }
  _onMonitorCharacteristic(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForDevice(
        _bleService.device.macAddress,
        _bleService.uuid,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => print(value))
    ;
  }
}