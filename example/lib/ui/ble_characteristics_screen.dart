import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/button_widget.dart';
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
            _label("ID :  ${characteristic.id}"),
            _label("UUID :  ${characteristic.uuid}"),
            _label("Service id :  ${characteristic.serviceId}"),
            _label("Service Uuid :  ${characteristic.serviceUuid}"),
            _label("Device id :  ${characteristic.deviceId}"),
            _label("Is readable :  ${characteristic.isReadable}"),
            _label("Is writable with response :  ${characteristic.isWritableWithResponse}"),
            _label("Is writable without response : ${characteristic.isWritableWithoutResponse}"),
            _label("Is notificable : ${characteristic.isNotificable}"),
            _label("Is indicatable :  ${characteristic.isIndicatable}"),
            _label("Is notifing : ${characteristic.isNotifing}"),
            _label("Value : ${characteristic.value}"),
            _button("Write characteristic",
                characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                    ? () =>_onWriteCharacteristic(characteristic) : null),
            _button( "Write characteristic for service",
              characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                ? () =>_onWriteCharacteristicForService(characteristic) : null,),
            _button("Write characteristic for device",
                characteristic.isWritableWithResponse || characteristic.isWritableWithoutResponse
                ? () =>_onWriteCharacteristicForDevice(characteristic) : null),
            _button("Read characteristic",
                characteristic.isReadable ? () =>_onReadCharacteristic(characteristic) : null),
            _button("Read characteristic for device",
                characteristic.isReadable ? () =>_onReadCharacteristicForDevice(characteristic) : null),
            _button("Read characteristic for service",
                characteristic.isReadable ? () =>_onReadCharacteristicForService(characteristic) : null),
            _button("Monitor characterisitic for device",
                characteristic.isNotificable ? () =>_onMonitorCharacteristicForDevice(characteristic) : null),
            _button("Monitor characterisitic for service",
                characteristic.isNotificable ? () =>_onMonitorCharacteristicForService(characteristic) : null),
            _button("Monitor characterisitic",
              characteristic.isNotificable ? () =>_onMonitorCharacteristic(characteristic) : null),
          ],
        ),
      ),
    );
  }

  _label(String text) =>
      new Text(text, style: new TextStyle(fontSize: 12.0),);

  _button(String text, VoidCallback onPressed) =>
      new Container (
        margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
        child: new CustomMaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          disabledColor: Colors.grey,
          child: new Text(text, style: new TextStyle(color: Colors.white),),
        ),
      );

  _onWriteCharacteristic(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristic(
        characteristic.id,
        [1],
        characteristic.isWritableWithResponse,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onWriteCharacteristicForService(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristicForService(
        _bleService.id,
        characteristic.uuid,
        [1],
        characteristic.isWritableWithResponse,
        new Uuid().v1())
        .then((value) => print(value));
  }

  _onWriteCharacteristicForDevice(Characteristic characteristic) {
    //TODO fix value ???
    FlutterBleLib.instance.writeCharacteristicForDevice(
        _bleService.device.id,
        _bleService.uuid,
        characteristic.uuid,
        [1],
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
        _bleService.device.id, _bleService.uuid, characteristic.uuid,
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
        _bleService.device.id,
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
        _bleService.device.id,
        _bleService.uuid,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => print(value))
    ;
  }
}