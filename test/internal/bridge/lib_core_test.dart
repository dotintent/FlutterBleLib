@Timeout(const Duration(milliseconds: 500))
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/internal/bridge/internal_bridge_lib.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mock/mock_peripheral.dart';
import '../../util/ble_error_jsons.dart';

const flutterBleLibMethodChannelName = 'flutter_ble_lib';
const monitorCharacteristicEventChannelName =
    flutterBleLibMethodChannelName + '/monitorCharacteristic';

void main() {
  FlutterBleLib bleLib = FlutterBleLib();
  Peripheral peripheral = PeripheralMock();
  MethodChannel methodChannel = MethodChannel(flutterBleLibMethodChannelName);
  MethodChannel eventMethodChannel =
      MethodChannel(monitorCharacteristicEventChannelName);

  setUp(() {
    when(peripheral.identifier).thenReturn("4B:99:4C:34:DE:77");
    methodChannel.setMockMethodCallHandler((call) => Future.value(""));
    eventMethodChannel.setMockMethodCallHandler((call) => Future.value(""));
  });

  Future<void> emitPlatformError(String errorJson) =>
      defaultBinaryMessenger.handlePlatformMessage(
          monitorCharacteristicEventChannelName,
          const StandardMethodCodec()
              .encodeErrorEnvelope(code: "irrelevant", details: errorJson),
          (ByteData data) {});

  test('monitorCharacteristicForIdentifier cancels on stream error', () async {
    expectLater(
        bleLib.monitorCharacteristicForIdentifier(peripheral, 123, null),
        emitsInOrder([
          emitsError(isInstanceOf<BleError>()),
          emitsDone,
        ]));
    await emitPlatformError(cancellationErrorJson);
  });

  test('monitorCharacteristicForDevice cancels on stream error', () async {
    expectLater(
        bleLib.monitorCharacteristicForDevice(
            peripheral, "serviceUuid", "characteristicUuid", null),
        emitsInOrder([
          emitsError(isInstanceOf<BleError>()),
          emitsDone,
        ]));
    await emitPlatformError(cancellationErrorJson);
  });

  test('monitorCharacteristicForService cancels on stream error', () async {
    expectLater(
        bleLib.monitorCharacteristicForService(
            peripheral, 123, "characteristicUuid", null),
        emitsInOrder([
          emitsError(isInstanceOf<BleError>()),
          emitsDone,
        ]));
    await emitPlatformError(cancellationErrorJson);
  });
}
