import 'dart:typed_data';

import 'package:flutter_ble_lib/blemulator/blemulator.dart';

class SensorTag extends SimulatedPeripheral {
  SensorTag(
      {String id = "4B:99:4C:34:DE:77",
      String name = "SensorTag",
      String localName = "SensorTag"})
      : super(
            name: name,
            id: id,
            advertisementInterval: Duration(milliseconds: 800),
            services: [
              SimulatedService(
                  uuid: "F000AA00-0451-4000-B000-000000000000",
                  isAdvertised: true,
                  characteristics: [
                    SimulatedCharacteristic(
                        uuid: "F000AA01-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Data"),
                    SimulatedCharacteristic(
                        uuid: "F000AA02-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Config"),
                    SimulatedCharacteristic(
                        uuid: "F000AA03-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([50]),
                        convenienceName: "IR Temperature Period"),
                  ],
                  convenienceName: "Temperature service"),
              SimulatedService(
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
