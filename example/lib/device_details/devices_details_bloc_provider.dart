import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib_example/repository/device_repository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

import 'device_details_bloc.dart';

class DeviceDetailsBlocProvider extends InheritedWidget {
  final DeviceDetailsBloc deviceDetailsBloc;

  DeviceDetailsBlocProvider({
    Key key,
    DeviceDetailsBloc deviceDetailsBloc,
    Widget child,
  })  : deviceDetailsBloc = deviceDetailsBloc ??
            DeviceDetailsBloc(DeviceRepository(), BleManager()),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DeviceDetailsBloc of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DeviceDetailsBlocProvider>()
      .deviceDetailsBloc;
}
