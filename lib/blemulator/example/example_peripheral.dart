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
                        uuid:
                            "12:25:00:00:00:00:00:00:00:00:B0:00:40:51:04:01:AA:00:F0",
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Data"),
                    SimulatedCharacteristic(
                        uuid:
                            "0A:29:00:00:00:00:00:00:00:00:B0:00:40:51:04:02:AA:00:F0",
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Config"),
                    SimulatedCharacteristic(
                        uuid:
                            "0A:2C:00:00:00:00:00:00:00:00:B0:00:40:51:04:03:AA:00:F0",
                        value: Uint8List.fromList([50]),
                        convenienceName: "IR Temperature Period"),
                  ],
                  convenienceName: "Temperature service"),
              SimulatedService(
                  uuid: "F000AA10-0451-4000-B000-000000000000",
                  isAdvertised: true,
                  characteristics: [
                    SimulatedCharacteristic(
                        uuid:
                            "12:30:00:00:00:00:00:00:00:00:B0:00:40:51:04:11:AA:00:F0",
                        value: Uint8List.fromList([0, 0]),
                        convenienceName: "Accelerometer Config"),
                    SimulatedCharacteristic(
                        uuid:
                            "0A:34:00:00:00:00:00:00:00:00:B0:00:40:51:04:12:AA:00:F0",
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
