import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_ble_lib/blemulator/blemulator.dart';

class SensorTag extends SimulatedPeripheral {
  static const String peripheralId = "4B:99:4C:34:DE:77";

  SensorTag(
      {String id = peripheralId,
      String name = "SensorTag",
      String localName = "SensorTag"})
      : super(
            name: name,
            id: id,
            advertisementInterval: Duration(milliseconds: 800),
            services: [
              SimulatedService(
                  peripheralId: peripheralId,
                  uuid: "F000AA00-0451-4000-B000-000000000000",
                  isAdvertised: true,
                  characteristics: [
                    TemperatureDataCharacteristic(),
                    TemperatureConfigCharacteristic(),
                    SimulatedCharacteristic(
                        uuid: "F000AA03-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([50]),
                        convenienceName: "IR Temperature Period"),
                  ],
                  convenienceName: "Temperature service"),
              SimulatedService(
                  peripheralId: peripheralId,
                  uuid: "F000AA10-0451-4000-B000-000000000000",
                  isAdvertised: true,
                  characteristics: [
                    SimulatedCharacteristic(
                        uuid: "F000AA12-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([0, 0]),
                        convenienceName: "Accelerometer Config"),
                    SimulatedCharacteristic(
                        uuid: "F000AA13-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([0, 0]),
                        convenienceName: "Accelerometer Period"),
                  ],
                  convenienceName: "Accelerometer Service")
            ]) {
    scanInfo.localName = localName;
  }

  @override
  Future<bool> onConnectRequest() async {
    await Future.delayed(Duration(milliseconds: 200));
    return super.onConnectRequest();
  }
}

class TemperatureDataCharacteristic extends SimulatedCharacteristic {
  TemperatureDataCharacteristic()
      : super(
          uuid: "F000AA01-0451-4000-B000-000000000000",
          value: Uint8List.fromList([101, 254, 64, 12]),
          convenienceName: "IR Temperature Config",
          isNotifiable: true,
        );

  void startEmittingValues() async {
    do {
      await Future.delayed(Duration(milliseconds: 500));
      if (isNotifying) {
        int t1 = Random().nextInt(200);
        int t2 = Random().nextInt(200);
        int t3 = Random().nextInt(200);
        int t4 = Random().nextInt(200);
        streamController.sink.add(Uint8List.fromList([t1, t2, t3, t4]));
      }
    } while (isNotifying);
  }

  void setNotifying(bool isNotifying) {
    this.isNotifying = isNotifying;
    if (isNotifying) {
      startEmittingValues();
    }
  }
}

class TemperatureConfigCharacteristic extends SimulatedCharacteristic {
  TemperatureConfigCharacteristic()
      : super(
          uuid: "F000AA02-0451-4000-B000-000000000000",
          value: Uint8List.fromList([101, 254, 64, 12]),
          convenienceName: "IR Temperature Data",
        );

  @override
  Future<void> write(Uint8List value) async {
    await super.write(value);
    TemperatureDataCharacteristic dataCharacteristic =
        service.characteristics().firstWhere(
              (characteristic) =>
                  characteristic is TemperatureDataCharacteristic,
            );
    dataCharacteristic.setNotifying(value.first == 1);
  }
}
