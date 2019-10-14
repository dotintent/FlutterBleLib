
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/device_details/device_details_bloc.dart';
import 'package:flutter_ble_lib_example/device_details/view/button_view.dart';
import 'package:flutter_ble_lib_example/device_details/view/logs_container_view.dart';

class ManualTestView extends StatelessWidget {

  final DeviceDetailsBloc _deviceDetailsBloc;

  ManualTestView(this._deviceDetailsBloc);

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _createControlPanel(),
          ),
        ),
        Expanded(
          flex: 7,
          child: LogsContainerView(_deviceDetailsBloc.logs),
        )
      ]),
    );
  }

  void _connect() {
    _deviceDetailsBloc.connect();
  }

  void _disconnect() {
    _deviceDetailsBloc.disconnectManual();
  }

  void _readRssi() {
    _deviceDetailsBloc.readRssi();
  }

  void _discovery() {
    _deviceDetailsBloc.discovery();
  }

  void _fetchConnectedDevices() {
    _deviceDetailsBloc.fetchConnectedDevices();
  }

  void _fetchKnownDevices() {
    _deviceDetailsBloc.fetchKnownDevices();
  }

  void _writeCharacteristicForPeripheral() {
    _deviceDetailsBloc.writeCharacteristicForPeripheral();
  }

  void _readCharacteristicForPeripheral() {
    _deviceDetailsBloc.readCharacteristicForPeripheral();
  }

  void _disableBluetooth() {
    _deviceDetailsBloc.disableBluetooth();
  }

  void _enableBluetooth() {
    _deviceDetailsBloc.enableBluetooth();
  }

  void _fetchBluetoothState() {
    _deviceDetailsBloc.fetchBluetoothState();
  }

  Column _createControlPanel() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView("Connect", action: _connect),
              ButtonView("Disconnect", action: _disconnect),
              ButtonView("Connected devices", action: _fetchConnectedDevices),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView("Read Rssi", action: _readRssi),
              ButtonView("Request MTU"),
              ButtonView("Known devices", action: _fetchKnownDevices),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView("Discovery", action: _discovery),
              ButtonView("Turn on temp", action: _writeCharacteristicForPeripheral),
              ButtonView("Read temp", action: _readCharacteristicForPeripheral),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView("Enable bluetooth", action: _enableBluetooth),
              ButtonView("Disable bluetooth", action: _disableBluetooth),
              ButtonView("Fetch BT State", action: _fetchBluetoothState),
            ],
          ),
        ),
      ],
    );
  }
}