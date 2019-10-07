
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib_example/device_details/device_details_bloc.dart';
import 'package:flutter_ble_lib_example/device_details/view/button_builder.dart';
import 'package:flutter_ble_lib_example/device_details/view/logs_container_view_builder.dart';

class AutoTestViewBuilder {

  DeviceDetailsBloc _deviceDetailsBloc;

  AutoTestViewBuilder(this._deviceDetailsBloc);

  Widget build() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _createAutoTestControlPanel(),
          ),
        ),
        Expanded(
          flex: 9,
          child: LogsContainerViewBuilder().build(_deviceDetailsBloc.logs),
        )
      ]),
    );
  }

  Widget _createAutoTestControlPanel() {
    return Row(
      children: <Widget>[
        ButtonBuilder().build("Start Auto Test", action: _startAutoTest),
      ],
    );
  }

  void _startAutoTest() {
    _deviceDetailsBloc.startAutoTest();
  }
}