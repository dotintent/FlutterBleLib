import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/ble_characteristics_screen.dart';


class BleServicesScreen extends StatefulWidget {
  final BleDevice _connectedDevice;
  final List<BleService> _services;

  BleServicesScreen(this._connectedDevice, this._services);

  @override
  State<StatefulWidget> createState() {
    return new BleServicesScreenState(_connectedDevice, _services);
  }
}

class BleServicesScreenState extends State<StatefulWidget> {
  final BleDevice _connectedDevice;
  final List<BleService> _services;

  BleServicesScreenState(this._connectedDevice, this._services);

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
      body: new BleServiceList(_connectedDevice, _services, context),
    );
  }
}

class ServiceItem extends StatelessWidget {

  final BleService _bleService;
  final VoidCallback _onCharacterisiticForDeviceClick;
  final VoidCallback _onCharacterisiticForServiceClick;

  ServiceItem(this._bleService,
      this._onCharacterisiticForDeviceClick,
      this._onCharacterisiticForServiceClick);

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
    return new Card(
      color: const Color.fromRGBO(69, 90, 100, 1.0),
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Service : ", style: titleStyle),
            new Text(_bleServiceInfo(), style: body1Style,),
            new Text(_bleDeviceInfo(), style: body2Style,),
            _button(
                "Characterisitic for Device",
                buttonStyle,
                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    () => _onCharacterisiticForDeviceClick()
            ),
            _button(
                "Characterisitic for Service",
                buttonStyle,
                const EdgeInsets.only(bottom: 10.0),
                    () => _onCharacterisiticForServiceClick()
            )
          ],
        ),
      ),
    );
  }

  _button(String text, TextStyle buttonStyle, EdgeInsets margin,
      VoidCallback onPressed) =>
      new Container (
        margin: margin,
        child: new MaterialButton(
          minWidth: 400.0,
          onPressed: onPressed,
          color: Colors.blueAccent,
          child: new Text(text, style: buttonStyle,),
        ),
      );

  _bleServiceInfo() => "ID :  ${_bleService.id}\nUUID : ${_bleService
      .uuid}\nIs primary : ${_bleService.isPrimary}\nBleDevice :";

  _bleDeviceInfo() =>
      "\tname : ${_bleService.device.name}\n\tid : ${_bleService.device
          .id}";
}

class BleServiceList extends StatefulWidget {


  final BleDevice _connectedDevice;

  final List<BleService> _services;

  final BuildContext _mainBuildContext;

  BleServiceList(this._connectedDevice, this._services, this._mainBuildContext);

  @override
  State<StatefulWidget> createState() =>
      new BleServiceListState(
          _connectedDevice, _services, _mainBuildContext);
}

class BleServiceListState extends State<StatefulWidget> {

  final BleDevice _connectedDevice;

  final List<BleService> _services;

  final BuildContext _mainBuildContext;

  BleServiceListState(this._connectedDevice, this._services,
      this._mainBuildContext);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _services == null ? 0 : _services.length,
        itemBuilder: (BuildContext context, int index) =>
        new ServiceItem(
          _services[index],
              () => _onCharacteristicForDeviceClick(_services[index]),
              () => _onCharacteristicForServiceClick(_services[index]),
        )
    );
  }


  _onCharacteristicForDeviceClick(final BleService service) {
    FlutterBleLib.instance
        .characteristicsForDevice(service.device.id, service.uuid)
        .then((characteristics) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext buildContext) =>
          new CharacteristicsScreen(service, characteristics)));
    });
  }

  _onCharacteristicForServiceClick(BleService service) {
    FlutterBleLib.instance
        .characteristicsForService(service.id)
        .then((characteristics) {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext buildContext) =>
          new CharacteristicsScreen(service, characteristics)));
    });
  }
}