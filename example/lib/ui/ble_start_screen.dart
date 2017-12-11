import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/ui/screen_names.dart' as ScreenNames;

class BleStartScreen extends StatelessWidget {

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
              new MaterialButton(
                  child: new Text(
                    "Create BleClient and start",
                    style: new TextStyle(color: Colors.white),
                  ),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    FlutterBleLib.instance.createClient();
                    Navigator.of(context).pushNamed(
                        ScreenNames.bleDevicesScreen);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}