import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/button_widget.dart';
import 'package:flutter_ble_lib_example/ui/insert_value_dialog.dart';
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

  String logValue = "";

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
    final TextStyle body1Style = Theme
        .of(context)
        .textTheme
        .body1;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text(
            "${_bleService.device.name ?? "Unkonwn"} device services."),
      ),
      body: new CharacteristicList(
          _bleService, _characteristics, context, onValuerPrint),
      bottomNavigationBar: new PreferredSize(
        preferredSize: const Size.fromHeight(24.0),
        child: new Theme(
          data: Theme.of(context).copyWith(
              accentColor: Colors.white, backgroundColor: Colors.blueGrey),
          child:
          new Container(
            color: Colors.blueGrey,
            padding: const EdgeInsets.all(10.0),
            child: new Text(logValue, style: body1Style,),
          ),
        ),
      ),
    );
  }

  onValuerPrint(String value) {
    setState(() => logValue = "Value is ${value != null ? value : ""}");
  }
}

class CharacteristicList extends StatefulWidget {


  final BleService _bleService;

  final List<Characteristic> _characteristic;

  final BuildContext _mainBuildContext;

  final dynamic _action;

  CharacteristicList(this._bleService, this._characteristic,
      this._mainBuildContext, this._action);

  @override
  State<StatefulWidget> createState() =>
      new CharacteristicListState(
          _bleService, _characteristic, _mainBuildContext, _action);
}

class CharacteristicItem extends StatelessWidget {


  final Characteristic _characteristic;

  final Map<String, VoidCallback> buttonData;

  CharacteristicItem(this._characteristic,
      final VoidCallback onWriteCharacteristicClick,
      final VoidCallback onWriteCharacteristicForDeviceClick,
      final VoidCallback onWriteCharacteristicForServiceClick,
      final VoidCallback onReadCharacteristicClick,
      final VoidCallback onReadCharacteristicForDeviceClick,
      final VoidCallback onReadCharacteristicForServiceClick,
      final VoidCallback onMonitorCharacteristicClick,
      final VoidCallback onMonitorCharacteristicForDeviceClick,
      final VoidCallback onMonitorCharacteristicForServiceClick,)
      : buttonData = {
    "Write characteristic": onWriteCharacteristicClick,
    "Write characteristic for device": onWriteCharacteristicForDeviceClick,
    "Write characteristic for service": onWriteCharacteristicForServiceClick,
    "Read characteristic": onReadCharacteristicClick,
    "Read characteristic for device": onReadCharacteristicForDeviceClick,
    "Read characteristic for service": onReadCharacteristicForServiceClick,
    "Monitor characterisitic": onMonitorCharacteristicClick,
    "Monitor characterisitic for device": onMonitorCharacteristicForDeviceClick,
    "Monitor characterisitic for service": onMonitorCharacteristicForServiceClick
  };


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
    final TextStyle buttonStyle = Theme
        .of(context)
        .textTheme
        .button;

    List<Widget> buttons = new List<Widget>();
    buttonData.forEach((k, v) => buttons.add(_button(k, v, buttonStyle)));
    return new Card(
      color: const Color.fromRGBO(69, 90, 100, 1.0),
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Characteristic : ", style: titleStyle,),
            new Text(_characteristicInfo(), style: body1Style,),
          ]
            ..addAll(buttons),
        ),
      ),
    );
  }

  _characteristicInfo() =>
      "ID :  ${_characteristic.id}\nUUID :  ${_characteristic
          .uuid}\nService id :  ${_characteristic
          .serviceId}\nService Uuid :  ${_characteristic
          .serviceUuid}\nDevice id :  ${_characteristic
          .deviceId}\nIs readable :  ${_characteristic
          .isReadable}\nIs writable with response :  ${_characteristic
          .isWritableWithResponse}\nIs writable without response : ${_characteristic
          .isWritableWithoutResponse}\nIs notificable : ${_characteristic
          .isNotificable}\nIs indicatable :  ${_characteristic
          .isIndicatable}\nIs notifing : ${_characteristic
          .isNotifing}\nValue : ${_characteristic.value}";

  _button(String text, VoidCallback onPressed, TextStyle buttonStyle) =>
      new Container (
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: new CustomMaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          disabledColor: Colors.grey,
          child: new Text(text, style: buttonStyle,),
        ),
      );
}


class CharacteristicListState extends State<StatefulWidget> {

  final BleService _bleService;

  final List<Characteristic> _characteristics;

  final BuildContext _mainBuildContext;

  final dynamic _action;

  CharacteristicListState(this._bleService, this._characteristics,
      this._mainBuildContext, this._action);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _characteristics == null ? 0 : _characteristics.length,
        itemBuilder: (BuildContext context, int index) {
          final Characteristic characteristic = _characteristics[index];
          return new CharacteristicItem(
            characteristic,
            characteristic.isWritableWithResponse ||
                characteristic.isWritableWithoutResponse
                ? () => _onWriteCharacteristic(characteristic) : null,
            characteristic.isWritableWithResponse ||
                characteristic.isWritableWithoutResponse
                ? () => _onWriteCharacteristicForDevice(characteristic)
                : null,
            characteristic.isWritableWithResponse ||
                characteristic.isWritableWithoutResponse
                ? () => _onWriteCharacteristicForService(characteristic)
                : null,
            characteristic.isReadable ? () =>
                _onReadCharacteristic(characteristic) : null,
            characteristic.isReadable ? () =>
                _onReadCharacteristicForDevice(characteristic) : null,
            characteristic.isReadable ? () =>
                _onReadCharacteristicForService(characteristic) : null,
            characteristic.isNotificable ? () =>
                _onMonitorCharacteristic(characteristic) : null,
            characteristic.isNotificable ? () =>
                _onMonitorCharacteristicForDevice(characteristic) : null,
            characteristic.isNotificable ? () =>
                _onMonitorCharacteristicForService(characteristic) : null,
          );
        }
    );
  }


  _onWriteCharacteristic(Characteristic characteristic) {
    showDialog(context: context,
        child: new InsertValueDialog(characteristic, sendAction: (data) {
          FlutterBleLib.instance.writeCharacteristic(
              characteristic.id,
              data,
              characteristic.isWritableWithResponse,
              new Uuid().v1())
              .then((value) => _action(value.value));
        },));
  }

  _onWriteCharacteristicForService(Characteristic characteristic) {
    showDialog(context: context,
        child: new InsertValueDialog(characteristic, sendAction: (data) {
          FlutterBleLib.instance.writeCharacteristicForService(
              _bleService.id,
              characteristic.uuid,
              data,
              characteristic.isWritableWithResponse,
              new Uuid().v1())
              .then((value) => _action(value.value));
        },));
  }

  _onWriteCharacteristicForDevice(Characteristic characteristic) {
    showDialog(context: context,
        child: new InsertValueDialog(characteristic, sendAction: (data) {
          FlutterBleLib.instance.writeCharacteristicForDevice(
              _bleService.device.id,
              _bleService.uuid,
              characteristic.uuid,
              data,
              characteristic.isWritableWithResponse,
              new Uuid().v1())
              .then((value) => _action(value.value));
        },));
  }

  _onReadCharacteristic(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristic(
        characteristic.id, new Uuid().v1())
        .then((value) => _action(value.value));
  }

  _onReadCharacteristicForDevice(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristicForDevice(
        _bleService.device.id, _bleService.uuid, characteristic.uuid,
        new Uuid().v1())
        .then((value) => _action(value.value));
  }

  _onReadCharacteristicForService(Characteristic characteristic) {
    FlutterBleLib.instance.readCharacteristicForService(
        _bleService.id, characteristic.uuid,
        new Uuid().v1())
        .then((value) => _action(value.value));
  }

  _onMonitorCharacteristicForDevice(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForDevice(
        _bleService.device.id,
        _bleService.uuid,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => _action(value.characteristic.value))
    ;
  }

  _onMonitorCharacteristicForService(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForService(
        _bleService.id,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => _action(value.characteristic.value))
    ;
  }

  _onMonitorCharacteristic(Characteristic characteristic) {
    FlutterBleLib.instance.monitorCharacteristicForDevice(
        _bleService.device.id,
        _bleService.uuid,
        characteristic.uuid,
        new Uuid().v1())
        .listen((value) => _action(value.characteristic.value))
    ;
  }
}