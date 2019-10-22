import 'dart:async';
import 'dart:math';
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
              TemperatureService(
                  uuid: "F000AA00-0451-4000-B000-000000000000",
                  isAdvertised: true,
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

class TemperatureService extends SimulatedService {
  static const String _temperatureDataUuid =
      "F000AA01-0451-4000-B000-000000000000";
  static const String _temperatureConfigUuid =
      "F000AA02-0451-4000-B000-000000000000";
  static const String _temperaturePeriodUuid =
      "F000AA03-0451-4000-B000-000000000000";

  bool _readingTemperature = false;

  TemperatureService({String uuid, bool isAdvertised, String convenienceName})
      : super(
            uuid: uuid,
            isAdvertised: isAdvertised,
            characteristics: [
              SimulatedCharacteristic(
                uuid: _temperatureDataUuid,
                value: Uint8List.fromList([101, 254, 64, 12]),
                convenienceName: "IR Temperature Data",
                isNotifiable: true,
              ),
              SimulatedCharacteristic(
                uuid: _temperatureConfigUuid,
                value: Uint8List.fromList([0]),
                convenienceName: "IR Temperature Config",
              ),
              SimulatedCharacteristic(
                  uuid: _temperaturePeriodUuid,
                  value: Uint8List.fromList([80]),
                  convenienceName: "IR Temperature Period"),
            ],
            convenienceName: convenienceName) {
    characteristicByUuid(_temperatureConfigUuid).monitor().listen((value) {
      int valueAsInt = value.buffer.asByteData().getUint8(8);
      _readingTemperature = value[0] == 1 ? true : false;
    });

    _emitTemperature();
  }

  void _emitTemperature() async {
    while (true) {
      Uint8List delayBytes =
          await characteristicByUuid(_temperaturePeriodUuid).read();
      int delay = delayBytes.buffer.asByteData().getUint8(0) * 10;
      await Future.delayed(Duration(milliseconds: delay));

      SimulatedCharacteristic temperatureDataCharacteristic =
          characteristicByUuid(_temperatureDataUuid);

      if (temperatureDataCharacteristic.isNotifying) {
        if (_readingTemperature) {
          temperatureDataCharacteristic
              .write(Uint8List.fromList([0, 0, 200, Random().nextInt(255)]));
        } else {
          temperatureDataCharacteristic.write(Uint8List.fromList([0, 0, 0, 0]));
        }
      }
    }
  }
}
