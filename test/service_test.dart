import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/manager_mock.dart';
import 'mock/mock_peripheral.dart';

void main() {
  Peripheral peripheral = PeripheralMock();
  ManagerForService managerForService = ManagerForServiceMock();
  ManagerForCharacteristic managerForCharacteristic =
      ManagerForCharacteristicMock();
  ManagerForDescriptor managerForDescriptor = ManagerForDescriptorMock();

  Service service = Service.fromJson({
    "serviceId": 1,
    "serviceUuid": "testUuid",
  }, peripheral, managerForService);

  Map<dynamic, dynamic> createRawCharacteristic(int seed) => <String, dynamic>{
        "characteristicUuid": seed.toString(),
        "id": seed,
        "isReadable": seed % 2 == 0,
        "isWritableWithResponse": seed % 2 == 0,
        "isWritableWithoutResponse": seed % 2 == 0,
        "isNotifiable": seed % 2 == 0,
        "isIndicatable": seed % 2 == 0,
        "value": base64Encode([seed])
      };

  CharacteristicWithValue createCharacteristic(int seed) =>
      CharacteristicWithValue.fromJson(
        createRawCharacteristic(seed),
        service,
        managerForCharacteristic,
      );

  Map<dynamic, dynamic> createRawDescriptor(int seed) => <String, dynamic>{
        "descriptorId": seed,
        "descriptorUuid": seed.toString(),
        "value": base64Encode([seed])
      };

  DescriptorWithValue createDescriptor(int seed) =>
      DescriptorWithValue.fromJson(
        createRawDescriptor(seed),
        createCharacteristic(seed),
        managerForDescriptor,
      );

  test("characteristics returns characteristics provided by manager", () async {
    //given
    when(managerForService.characteristicsForService(service))
        .thenAnswer((_) => Future.value([
              createCharacteristic(0),
              createCharacteristic(1),
              createCharacteristic(2),
            ]));

    //when
    var characteristics = await service.characteristics();

    //then
    expect(
        characteristics,
        equals([
          createCharacteristic(0),
          createCharacteristic(1),
          createCharacteristic(2),
        ]));
  });

  test("characteristics returns expected characteristics provided by manager",
      () async {
    //given
    when(managerForService.readCharacteristicForService(
            peripheral, service, "characteristicUuid", "123"))
        .thenAnswer((_) => Future.value(createCharacteristic(0)));

    //when
    var characteristics = await service.characteristics();

    //then
    expect(
        characteristics,
        equals([
          createCharacteristic(0),
          createCharacteristic(1),
          createCharacteristic(2),
        ]));
  });

  test("readCharacteristic returns expected characteristic", () async {
    //given
    when(managerForService.readCharacteristicForService(
            peripheral, service, "123", "456"))
        .thenAnswer((_) => Future.value(createCharacteristic(0)));

    //when
    var characteristic =
        await service.readCharacteristic("123", transactionId: "456");

    //then
    expect(characteristic, equals(createCharacteristic(0)));
  });

  test("readCharacteristic reads characteristic using manager", () async {
    //when
    service.readCharacteristic("123", transactionId: "456");

    //then
    verify(
      managerForService.readCharacteristicForService(
          peripheral, service, "123", "456"),
    );
  });

  test("readDescriptor returns expected descriptor", () async {
    //given
    when(managerForService.readDescriptorForService(
            service, "123", "456", "789"))
        .thenAnswer((_) => Future.value(createDescriptor(0)));

    //when
    var characteristic =
        await service.readDescriptor("123", "456", transactionId: "789");

    //then
    expect(characteristic, equals(createDescriptor(0)));
  });

  test("readDescriptor reads characteristic using manager", () async {
    //when
    service.readCharacteristic("123", transactionId: "456");

    //then
    verify(
      managerForService.readDescriptorForService(service, "123", "456", "789"),
    );
  });

  test("writeCharacteristic returns expected characteristic", () async {
    //given
    when(managerForService.writeCharacteristicForService(peripheral, service,
            "123", Uint8List.fromList([1, 2, 3, 4]), false, "456"))
        .thenAnswer((_) => Future.value(createCharacteristic(0)));

    //when
    var characteristic = await service.writeCharacteristic(
      "123",
      Uint8List.fromList([1, 2, 3, 4]),
      false,
      transactionId: "456",
    );

    //then
    expect(characteristic, equals(createCharacteristic(0)));
  });

  test("writeCharacteristic reads characteristic using manager", () async {
    //when
    service.writeCharacteristic("123", Uint8List.fromList([1, 2, 3, 4]), false,
        transactionId: "456");

    //then
    verify(
      managerForService.writeCharacteristicForService(peripheral, service,
          "123", Uint8List.fromList([1, 2, 3, 4]), false, "456"),
    );
  });

  test("writeDescriptor returns expected descriptor", () async {
    //given
    when(managerForService.writeDescriptorForService(
            service, "123", "456", Uint8List.fromList([1, 2, 3, 4]), "789"))
        .thenAnswer((_) => Future.value(createDescriptor(0)));

    //when
    var characteristic = await service.writeDescriptor(
        "123", "456", Uint8List.fromList([1, 2, 3, 4]),
        transactionId: "789");

    //then
    expect(characteristic, equals(createDescriptor(0)));
  });

  test("writeDescriptor writes descriptor using manager", () async {
    //when
    service.writeDescriptor("123", "456", Uint8List.fromList([1, 2, 3, 4]),
        transactionId: "789");

    //then
    verify(
      managerForService.writeDescriptorForService(
          service, "123", "456", Uint8List.fromList([1, 2, 3, 4]), "789"),
    );
  });

  test("monitorCharacteristic streams expected characteristic", () async {
    //given
    var streamController = StreamController<CharacteristicWithValue>();
    when(managerForService.monitorCharacteristicForService(
            peripheral, service, "123", "456"))
        .thenAnswer((_) => streamController.stream);

    //when
    var characteristicNotifications =
        service.monitorCharacteristic("123", transactionId: "456");
    streamController.sink.add(createCharacteristic(0));
    streamController.sink.add(createCharacteristic(1));
    streamController.sink.add(createCharacteristic(2));
    streamController.close();

    //then
    expect(
        characteristicNotifications,
        emitsInOrder([
          emits(equals(createCharacteristic(0))),
          emits(equals(createCharacteristic(1))),
          emits(equals(createCharacteristic(2))),
          emitsDone
        ]));
  });

  test("monitorCharacteristic monitors characteristic using manager", () async {
    //when
    service.monitorCharacteristic("123", transactionId: "456");

    //then
    verify(
      managerForService.monitorCharacteristicForService(
          peripheral, service, "123", "456"),
    );
  });
}
