import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

abstract class BleDevice {
  String id;
  int counter = 0;
  final String name;
  DeviceCategory _category;
  bool _isConnected = false;
  Peripheral peripheral;

  bool get isConnected =>
      _isConnected;

  DeviceCategory get category => _category;

  BleDevice(this.name, this.id, this.peripheral) {
    _category = _nameToCategory(name);
    if(this.name == null) {

    }
  }

  factory BleDevice.connected(BleDevice bleDevice) {
    return ConnectedBleDevice(bleDevice.name, bleDevice.id, bleDevice.peripheral);
  }

  factory BleDevice.notConnected(String name, String id, Peripheral peripheral) {
    return DisconnectedBleDevice(name, id, peripheral);
  }

  DeviceCategory _nameToCategory(String name) {
    if (name == "SensorTag") {
      return DeviceCategory.sensorTag;
    } else if (name!= null && name.startsWith("Hex")) {
      return DeviceCategory.hex;
    } else {
      return DeviceCategory.other;
    }
  }

  @override
  int get hashCode => 123;

  @override
  bool operator ==(other) =>
      other is BleDevice && this.name != null && other.name != null && compareAsciiLowerCase(this.name, other.name) == 0;

  @override
  String toString() {
    return 'BleDevice{counter: $counter, name: $name}';
  }

  void abandon();
}

class DisconnectedBleDevice extends BleDevice {
  StreamController<BleDevice> _devicesInConnectingProcess;

  DisconnectedBleDevice(String name, String id, Peripheral peripheral)
      : super(name ?? "", id, peripheral);

  @override
  String toString() {
    return 'DisconnectedBleDevice{} ${super.toString()}';
  }

  void abandon() {
    _devicesInConnectingProcess?.close();
  }
}

class ConnectedBleDevice extends BleDevice {

  ConnectedBleDevice(String name, String id, Peripheral peripheral)
      : super(name ?? "", id, peripheral);

  @override
  void abandon() {
  }
}

enum DeviceCategory { sensorTag, hex, other }
