import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib_example/model/ble_device.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

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
    _appStateSubscription =
        _deviceDetailsBloc.disconnectedDevice.listen((bleDevice) async {
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
    return WillPopScope(
      onWillPop: () {
        return _deviceDetailsBloc.disconnect().then((_) {
          return false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth device'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder<BleDevice>(
                initialData: _deviceDetailsBloc.device.value,
                stream: _deviceDetailsBloc.device,
                builder: (context, snapshot) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(snapshot.data.toString()),
                    StreamBuilder<PeripheralConnectionState>(
                      initialData: _deviceDetailsBloc.connectionState.value,
                      stream: _deviceDetailsBloc.connectionState,
                      builder: (context, snapshot) =>
                          Text(snapshot.data.toString()),
                    ),
                    Flexible(
                      child: StreamBuilder<List<DebugLog>>(
                        initialData: [],
                        stream: _deviceDetailsBloc.logs,
                        builder: (context, logs) => _buildLogs(context, logs),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context, AsyncSnapshot<List<DebugLog>> logs) {
    return ListView.builder(
      itemCount: logs.data.length,
      shrinkWrap: true,
      itemBuilder: (buildContext, index) => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  logs.data[index].time,
                  style: TextStyle(fontSize: 9),
                ),
              ),
              Flexible(
                child: Text(logs.data[index].content,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 9)),
              ),
            ],
          ),
        ),
      ),
    );
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
