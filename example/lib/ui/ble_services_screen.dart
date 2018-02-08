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
            buildItem(_services[ index], _mainBuildContext)
    );
  }

  Card buildItem(BleService bleService, BuildContext context) {
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
            new Text("ID : + ${bleService.id}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("UUID : ${bleService.uuid}",
              style: new TextStyle(fontSize: 12.0),),
            new Text("Is primary : ${bleService.isPrimary}",
              style: new TextStyle(fontSize: 12.0),),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("BleDevice : ",
                  style: new TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold,),),
                new Text("\tname : ${bleService.device.name}",
                  style: new TextStyle(fontSize: 10.0),),
                new Text(
                  "\tmac address : ${bleService.device.id}",
                  style: new TextStyle(fontSize: 10.0),),
              ],
            ),
            new Container (
              margin: const EdgeInsets.only(top:10.0, bottom: 10.0),
              child: new MaterialButton(
                  minWidth: 400.0,
                  onPressed: () => _onCharacteristicForDeviceClick(bleService),
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
                  onPressed: () => _onCharacteristicForServiceClick(bleService),
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

  _onCharacteristicForDeviceClick(final BleService service) {
    FlutterBleLib.instance
        .characteristicsForDevice(service.device.id, service.uuid)
        .then((characteristics) { Navigator.of(context).push(new MaterialPageRoute(
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