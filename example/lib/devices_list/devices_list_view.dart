import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ble_lib_example/model/ble_device.dart';

import 'devices_bloc.dart';
import 'devices_bloc_provider.dart';
import 'hex_painter.dart';

typedef DeviceTapListener = void Function();

class DevicesListScreen extends StatefulWidget {
  @override
  State<DevicesListScreen> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DevicesListScreen> {
  DevicesBloc? _devicesBloc;
  StreamSubscription<BleDevice>? _appStateSubscription;
  bool _shouldRunOnResume = true;

  @override
  void didUpdateWidget(DevicesListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    Fimber.d("didUpdateWidget");
  }

  void _onPause() {
    Fimber.d("onPause");
    _appStateSubscription?.cancel();
    _devicesBloc?.dispose();
  }

  void _onResume() {
    Fimber.d("onResume");
    final devicesBloc = _devicesBloc;
    if (devicesBloc == null) {
      Fimber.d("onResume:: no devicesBloc present");
      return;
    }
    devicesBloc.init();
    _appStateSubscription = devicesBloc.pickedDevice.listen((bleDevice) async {
      Fimber.d("navigate to details");
      _onPause();
      await Navigator.pushNamed(context, "/details");
      setState(() {
        _shouldRunOnResume = true;
      });
      Fimber.d("back from details");
    });
  }

  void _runOnResume() {
    if (!_shouldRunOnResume) return;
    _shouldRunOnResume = false;
    _onResume();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Fimber.d("DeviceListScreenState didChangeDependencies");
    if (_devicesBloc == null) {
      _devicesBloc = DevicesBlocProvider.of(context);
      _runOnResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    Fimber.d("build DeviceListScreenState");
    _runOnResume();
    final devicesBloc = _devicesBloc;
    if (devicesBloc == null) {
      throw Exception();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
      ),
      body: StreamBuilder<List<BleDevice>>(
        initialData: devicesBloc.visibleDevices.valueOrNull ?? <BleDevice>[],
        stream: devicesBloc.visibleDevices,
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: devicesBloc.refresh,
          child: DevicesList(devicesBloc, snapshot.data),
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

class DevicesList extends ListView {
  DevicesList(DevicesBloc devicesBloc, List<BleDevice>? devices)
      : super.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                ),
            itemCount: devices?.length ?? 0,
            itemBuilder: (context, i) {
              Fimber.d("Build row for $i");
              final device = devices![i];
              return _buildRow(
                  context, device, _createTapListener(devicesBloc, device));
            });

  static DeviceTapListener _createTapListener(
      DevicesBloc devicesBloc, BleDevice bleDevice) {
    return () {
      Fimber.d("clicked device: ${bleDevice.name}");
      devicesBloc.devicePicker.add(bleDevice);
    };
  }

  static Widget _buildAvatar(BuildContext context, BleDevice device) {
    switch (device.category) {
      case DeviceCategory.sensorTag:
        return CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/ti_logo.png'),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary);
      case DeviceCategory.hex:
        return CircleAvatar(
            child: CustomPaint(painter: HexPainter(), size: Size(20, 24)),
            backgroundColor: Colors.black);
      case DeviceCategory.other:
      default:
        return CircleAvatar(
            child: Icon(Icons.bluetooth),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white);
    }
  }

  static Widget _buildRow(BuildContext context, BleDevice device,
      DeviceTapListener deviceTapListener) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: _buildAvatar(context, device),
      ),
      title: Text(device.name),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Icon(Icons.chevron_right, color: Colors.grey),
      ),
      subtitle: Column(
        children: <Widget>[
          Text(
            device.id.toString(),
            style: TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      onTap: deviceTapListener,
      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
    );
  }
}
