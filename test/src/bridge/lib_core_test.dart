import 'dart:async';
@Timeout(const Duration(milliseconds: 500))
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_internal.dart';
import 'package:flutter_ble_lib/src/_constants.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import './lib_core_test.mocks.dart';

import '../../json/ble_error_jsons.dart';

const flutterBleLibMethodChannelName = 'flutter_ble_lib';
const monitorCharacteristicEventChannelName =
    flutterBleLibMethodChannelName + '/monitorCharacteristic';

@GenerateMocks([Peripheral, ManagerForService, ManagerForCharacteristic])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FlutterBleLib bleLib;
  Peripheral peripheral = MockPeripheral();
  MethodChannel methodChannel = MethodChannel(flutterBleLibMethodChannelName);
  MethodChannel eventMethodChannel =
      MethodChannel(monitorCharacteristicEventChannelName);

  setUp(() {
    bleLib = FlutterBleLib(InternalBleManager());
    when(peripheral.identifier).thenReturn("4B:99:4C:34:DE:77");
    methodChannel.setMockMethodCallHandler((call) => Future.value(""));
    eventMethodChannel.setMockMethodCallHandler((call) => Future.value(""));
  });

  Future<void> emitPlatformError(String errorJson) =>
      ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
          monitorCharacteristicEventChannelName,
          const StandardMethodCodec()
              .encodeErrorEnvelope(code: "irrelevant", details: errorJson),
          (data) {});

  Future<void> emitMonitoringEvent(String eventJson) =>
      ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
          monitorCharacteristicEventChannelName,
          const StandardMethodCodec().encodeSuccessEnvelope(eventJson),
          (data) {});

  Future<void> emitStreamCompletion() =>
      ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
        monitorCharacteristicEventChannelName,
        null,
        (data) {},
      );

  CharacteristicWithValueAndTransactionId createCharacteristicFromDecodedJson(
      Map<String, dynamic> decodedRoot) {
    Map<String, dynamic> decodedCharacteristic = decodedRoot["characteristic"];
    String transactionId = decodedRoot["transactionId"];
    return CharacteristicWithValueAndTransactionId.fromJson(
      decodedCharacteristic,
      Service.fromJson(decodedRoot, peripheral, MockManagerForService()),
      MockManagerForCharacteristic(),
    ).setTransactionId(transactionId);
  }

  Map<String, dynamic> createRawCharacteristic(
          {int? id,
          int? serviceId,
          String? serviceUuid,
          String? characteristicUuid,
          String? transactionId,
          String? base64value}) =>
      <String, dynamic>{
        "serviceUuid": serviceUuid,
        "serviceId": serviceId,
        "transactionId": transactionId,
        "characteristic": <String, dynamic>{
          "characteristicUuid": characteristicUuid,
          "id": id,
          "isReadable": true,
          "isWritableWithResponse": false,
          "isWritableWithoutResponse": false,
          "isNotifiable": true,
          "isIndicatable": false,
          "value": base64value ?? ""
        }
      };

  test('monitorCharacteristicForIdentifier cancels on stream error', () async {
    final fut = expectLater(
      bleLib.monitorCharacteristicForIdentifier(peripheral, 123, "asdasd"),
      emitsInOrder([
        emitsError(isInstanceOf<BleError>()),
        emitsDone,
      ])
    );
    await emitPlatformError(cancellationErrorJson);
    await fut;
  });

  test('monitorCharacteristicForDevice cancels on stream error', () async {
    String nullStr = "";
    expectLater(
        bleLib.monitorCharacteristicForDevice(
            peripheral, "serviceUuid", "characteristicUuid", nullStr),
        emitsInOrder([
          emitsError(isInstanceOf<BleError>()),
          emitsDone,
        ]));
    await emitPlatformError(cancellationErrorJson);
  });

  test('monitorCharacteristicForService cancels on stream error', () async {
    String nullStr = "";
    expectLater(
        bleLib.monitorCharacteristicForService(
            peripheral, 123, "characteristicUuid", nullStr),
        emitsInOrder([
          emitsError(isInstanceOf<BleError>()),
          emitsDone,
        ]));
    await emitPlatformError(cancellationErrorJson);
  });

  test(
      'monitorCharacteristicForIdentifier streams events with matching characteristic id and transaction id',
      () async {
    expectLater(
        bleLib.monitorCharacteristicForIdentifier(peripheral, 1, "1"),
        emitsInOrder([
          emits(equals(Uint8List.fromList([1, 0, 0, 0]))),
          emitsDone
        ]));

    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        id: 1, transactionId: "1", base64value: "AQAAAA=="))); //[1,0,0,0]
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        id: 1, transactionId: "2", base64value: "AAEAAA=="))); //[0,1,0,0]
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        id: 2, transactionId: "1", base64value: "AAABAA=="))); //[0,0,1,0]
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        id: 2, transactionId: "2", base64value: "AAAAAQ=="))); //[0,0,0,1]
    await emitStreamCompletion();
  });

  test(
      'monitorCharacteristicForDevice streams events with matching characteristic uuid, service uuid and transaction id',
      () async {
    expectLater(
      bleLib.monitorCharacteristicForDevice(
        peripheral, 
        "serviceUuid", 
        "characteristicUuid", 
        "1"
      ),
      emitsInOrder([
        emits(
          equals(
            createCharacteristicFromDecodedJson(
              createRawCharacteristic(
                serviceUuid: "serviceUuid",
                characteristicUuid: "characteristicUuid",
                transactionId: "1"
              )
            )
          )
        ),
        emitsDone
      ])
    );

    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceUuid: "serviceUuid",
        characteristicUuid: "characteristicUuid",
        transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceUuid: "serviceUuid",
        characteristicUuid: "fakeUuid",
        transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceUuid: "fakeUuid",
        characteristicUuid: "characteristicUuid",
        transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceUuid: "serviceUuid",
        characteristicUuid: "characteristicUuid",
        transactionId: "2")));
    await emitStreamCompletion();
  });

  test(
      'monitorCharacteristicForService streams events with matching service id, characteristic uuid and transaction id',
      () async {
    expectLater(
        bleLib.monitorCharacteristicForService(
            peripheral, 1, "characteristicUuid", "1"),
        emitsInOrder([
          emits(equals(
              createCharacteristicFromDecodedJson(createRawCharacteristic(
            serviceId: 1,
            characteristicUuid: "characteristicUuid",
            transactionId: "1",
          )))),
          emitsDone
        ]));

    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceId: 1,
        characteristicUuid: "characteristicUuid",
        transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceId: 1, characteristicUuid: "fakeUuid", transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceId: 2,
        characteristicUuid: "characteristicUuid",
        transactionId: "1")));
    await emitMonitoringEvent(jsonEncode(createRawCharacteristic(
        serviceId: 1,
        characteristicUuid: "characteristicUuid",
        transactionId: "2")));
    await emitStreamCompletion();
  });

  test(
    "Monitoring transaction is cancelled after unsubscribing all subscribers from monitoring stream",
    () async {
      //given
      Stream<Uint8List> monitoringStream =
          bleLib.monitorCharacteristicForIdentifier(peripheral, 1, "1");
      StreamSubscription subscription = monitoringStream.listen((_) {});

      StreamSubscription subscription1 = monitoringStream.listen((_) {});

      int calledCount = 0;
      methodChannel.setMockMethodCallHandler((call) {
        if (call.method == MethodName.cancelTransaction &&
            call.arguments[ArgumentName.transactionId] == "1") {
          calledCount++;
        }
        return Future.value("");
      });

      //when
      await subscription.cancel();
      await subscription1.cancel();

      //then
      expect(calledCount, 1);
    },
  );

  test(
    "Monitoring transaction is cancelled after unsubscribing the only subscriber from monitoring stream",
    () async {
      //given
      Stream<Uint8List> monitoringStream =
          bleLib.monitorCharacteristicForIdentifier(peripheral, 1, "1");
      StreamSubscription subscription = monitoringStream.listen((_) {});

      int calledCount = 0;
      methodChannel.setMockMethodCallHandler((call) {
        if (call.method == MethodName.cancelTransaction &&
            call.arguments[ArgumentName.transactionId] == "1") {
          calledCount++;
        }
        return Future.value("");
      });

      //when
      await subscription.cancel();

      //then
      expect(calledCount, 1);
    },
  );

  test(
    "Monitoring transaction is not cancelled after unsubscribing only one subscriber from monitoring stream",
    () async {
      //given
      Stream<Uint8List> monitoringStream =
          bleLib.monitorCharacteristicForIdentifier(peripheral, 1, "1");
      StreamSubscription subscription = monitoringStream.listen((_) {});

      monitoringStream.listen((_) {});

      int calledCount = 0;
      methodChannel.setMockMethodCallHandler((call) {
        if (call.method == MethodName.cancelTransaction &&
            call.arguments[ArgumentName.transactionId] == "1") {
          calledCount++;
        }
        return Future.value("");
      });

      //when
      await subscription.cancel();

      //then
      expect(calledCount, 0);
    },
  );
}
