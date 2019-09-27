import 'dart:typed_data';

import 'package:flutter_ble_lib/blemulator/blemulator.dart';

class SensorTag extends SimulatedPeripheral {
  SensorTag()
      : super("SensorTag", "4B:99:4C:34:DE:77", Duration(milliseconds: 500), [
          SimulatedService(
              "F000AA00-0451-4000-B000-000000000000",
              true,
              [
                SimulatedCharacteristic(
                    "12:25:00:00:00:00:00:00:00:00:B0:00:40:51:04:01:AA:00:F0",
                    Uint8List.fromList([0]),
                    convenienceName: "IR Temperature Data"),
                SimulatedCharacteristic(
                    "0A:29:00:00:00:00:00:00:00:00:B0:00:40:51:04:02:AA:00:F0",
                    Uint8List.fromList([0]),
                    convenienceName: "IR Temperature Config"),
                SimulatedCharacteristic(
                    "0A:2C:00:00:00:00:00:00:00:00:B0:00:40:51:04:03:AA:00:F0",
                    Uint8List.fromList([50]),
                    convenienceName: "IR Temperature Period"),
              ],
              convenienceName: "Temperature service"),
          SimulatedService(
              "F000AA10-0451-4000-B000-000000000000",
              true,
              [
                SimulatedCharacteristic(
                    "12:30:00:00:00:00:00:00:00:00:B0:00:40:51:04:11:AA:00:F0",
                    Uint8List.fromList([0, 0]),
                    convenienceName: "Accelerometer Config"),
                SimulatedCharacteristic(
                    "0A:34:00:00:00:00:00:00:00:00:B0:00:40:51:04:12:AA:00:F0",
                    Uint8List.fromList([0, 0]),
                    convenienceName: "Accelerometer Period"),
              ],
              convenienceName: "Accelerometer Service")
        ]) {
    scanInfo.localName = "SensorTag";
  }

  @override
  Future<bool> onConnectRequest() async {
    return true;
  }

  @override
  Future<void> onDiscoveryRequest() async {
    return;
  }
}
