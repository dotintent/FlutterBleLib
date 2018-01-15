import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/screen_names.dart' as ScreenNames;

class BleStartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new BleStartScreenState();
  }
}

class BleStartScreenState extends State<BleStartScreen> {

  LogLevel _currentLogLevel = LogLevel.NONE;
  BluetoothState _currentState = BluetoothState.POWERED_ON;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Ble Library Example"),
      ),
      body: new Container(
        padding: new EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0, top: 32.0
        ),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container (
                margin: const EdgeInsets.only(bottom: 32.0),
                child: new Text(
                  "Welcome in Flutter Ble Example App. Please tap on button to start working with ble features.",
                  style: new TextStyle(
                    fontSize: 16.0,),
                ),
              ),
              new Container (
                margin: const EdgeInsets.only(bottom: 18.0),
                child: new MaterialButton(
                  child: new Text(
                    "Create BleClient and start",
                    style: new TextStyle(color: Colors.white),
                  ),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed:
                  _currentState == BluetoothState.POWERED_ON
                      ? _onCreateButtonClick
                      : null,
                ),
              ),
              new Container (
                margin: const EdgeInsets.only(bottom: 18.0),
                child: new PopupMenuButton<LogLevel>( // overflow menu
                  child: new Container(
                    padding: const EdgeInsets.all(12.0),
                    child: new Text(
                      _currentLogLevel.toString(),
                      style: new TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                  ),
                  onSelected: (logLevel) => _onSelect(logLevel),
                  itemBuilder: (BuildContext context) {
                    return LogLevel.values.map((LogLevel choice) {
                      return new PopupMenuItem<LogLevel>(
                        value: choice,
                        child: new Text(choice.toString()),
                      );
                    }).toList();
                  },
                ),
              ),
              new Container (
                margin: const EdgeInsets.only(bottom: 18.0),
                child: new MaterialButton(
                    child: new Text(
                      "Get log level",
                      style: new TextStyle(color: Colors.white),
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () =>
                        FlutterBleLib.instance.logLevel().then((logLevel) =>
                            print(logLevel))
                ),
              ),
              new Container (
                margin: const EdgeInsets.only(bottom: 18.0),
                child: new Text(
                  _currentState?.toString() ?? "Please get current state",
                ),
              ),
              new Container (
                margin: const EdgeInsets.only(bottom: 18.0),
                child: new MaterialButton(
                    child: new Text(
                      "Get current state",
                      style: new TextStyle(color: Colors.white),
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: _onGetCurrentStateClick
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onCreateButtonClick() {
    FlutterBleLib.instance.createClient();
    Navigator.of(context).pushNamed(
        ScreenNames.bleDevicesScreen);
  }

  _onSelect(LogLevel logLevel) {
    FlutterBleLib.instance.setLogLevel(logLevel);
    setState(() {
      _currentLogLevel = logLevel;
    });
  }

  _onGetCurrentStateClick() {
    FlutterBleLib.instance.state().then((state) =>
        setState(() {
          print(state);
          _currentState = state;
        }));
  }
}