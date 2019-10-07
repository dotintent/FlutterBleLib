
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/device_details/device_details_bloc.dart';
import 'package:flutter_ble_lib_example/device_details/view/button_builder.dart';
import 'package:flutter_ble_lib_example/device_details/view/logs_container_view_builder.dart';

class ManualTestViewBuilder {

  DeviceDetailsBloc _deviceDetailsBloc;

  ManualTestViewBuilder(this._deviceDetailsBloc);

  Widget build() {
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
          child: LogsContainerViewBuilder().build(_deviceDetailsBloc.logs),
        )
      ]),
    );
  }

  Column _createControlPanel() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonBuilder().build("Connect"),
              ButtonBuilder().build("Disconnect"),
              ButtonBuilder().build("Connected devices"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonBuilder().build("Read Rssi"),
              ButtonBuilder().build("Request MTU"),
              ButtonBuilder().build("Known devices"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonBuilder().build("Read Rssi"),
              ButtonBuilder().build("Request MTU"),
              ButtonBuilder().build("Known devices"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonBuilder().build("Read Rssi"),
              ButtonBuilder().build("Request MTU"),
              ButtonBuilder().build("Known devices"),
            ],
          ),
        ),
      ],
    );
  }
}