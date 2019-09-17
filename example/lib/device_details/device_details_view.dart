
import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib_example/model/ble_device.dart';

import 'device_details_bloc.dart';
import 'devices_details_bloc_provider.dart';

class DeviceDetailsView extends StatefulWidget {
  @override
  State<DeviceDetailsView> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DeviceDetailsView> {
  DeviceDetailsBloc _deviceDetailsBloc;
  StreamSubscription _appStateSubscription;

  void _onPause() {
    Fimber.d("onPause");
    _appStateSubscription.cancel();
    _deviceDetailsBloc.dispose();
  }

  void _onResume() {
    Fimber.d("onResume");
    _deviceDetailsBloc.init();
    _appStateSubscription = _deviceDetailsBloc.disconnectedDevice.listen((bleDevice) async {
      Fimber.d("navigate to details");
      _onPause();
      Navigator.pop(context);
      _shouldRunOnResume = true;
      Fimber.d("back from details");
    });
  }

  bool _shouldRunOnResume = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Fimber.d("DeviceListScreenState didChangeDependencies");
    if (_deviceDetailsBloc == null) {
      _deviceDetailsBloc = DeviceDetailsBlocProvider.of(context);
      if (_shouldRunOnResume) {
        _shouldRunOnResume = false;
        _onResume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("build DevicDetailsScreenState");
    if (_shouldRunOnResume) {
      _shouldRunOnResume = false;
      _onResume();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth device'),
      ),
      body: StreamBuilder<BleDevice>(
        initialData: _deviceDetailsBloc.device.value,
        stream: _deviceDetailsBloc.device,
        builder: (context, snapshot) =>
            Center(
                child: Column(
                    children: <Widget>[
                        Text(snapshot.data.toString()),
                        RaisedButton(
                          onPressed: () { _deviceDetailsBloc.disconnect(); },
                          child: Text("Disconnect"),
                        )
                    ]
                )
      ),
    ));
  }

  @override
  void dispose() {
    Fimber.d("Dispose DeviceListScreenState");
    _onPause();
    super.dispose();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void reassemble() {
    Fimber.d("reassemble");
    super.reassemble();
  }
}