import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/characteristic_mock.dart';
import 'mock/manager_mock.dart';
import 'test_util/descriptor_generator.dart';

void main() {
  ManagerForDescriptor managerForDescriptor = ManagerForDescriptorMock();
  DescriptorGenerator descriptorGenerator =
      DescriptorGenerator(managerForDescriptor);

  DescriptorWithValue createDescriptor(int seed) =>
      descriptorGenerator.create(seed, CharacteristicMock());

  Descriptor descriptor = createDescriptor(123);

  tearDown(() {
    clearInteractions(managerForDescriptor);
  });

  test("read returns expected value", () async {
    //given
    when(managerForDescriptor.readDescriptorForIdentifier(descriptor, "456"))
        .thenAnswer((_) => Future.value(Uint8List.fromList([1, 2, 3, 4])));

    //when
    var value = await descriptor.read(transactionId: "456");

    //then
    expect(value, equals(Uint8List.fromList([1, 2, 3, 4])));
  });

  test("read reads descriptor's value using manager", () {
    //when
    descriptor.read(transactionId: "456");

    //then
    verify(
      managerForDescriptor.readDescriptorForIdentifier(descriptor, "456"),
    );
  });

  test(
      "read reads descriptor's value with generated transactionId using manager",
      () {
    //when
    descriptor.read(transactionId: null);

    //then
    verify(
      managerForDescriptor.readDescriptorForIdentifier(
          descriptor, argThat(isNotNull)),
    );
  });

  test("write writes descriptor's value using manager", () {
    //when
    descriptor.write(Uint8List.fromList([1, 2, 3, 4]), transactionId: "456");

    //then
    verify(
      managerForDescriptor.writeDescriptorForIdentifier(
          descriptor, Uint8List.fromList([1, 2, 3, 4]), "456"),
    );
  });

  test(
      "write writes descriptor's value with generated transactionId using manager",
      () {
    //when
    descriptor.write(Uint8List.fromList([1, 2, 3, 4]), transactionId: null);

    //then
    verify(
      managerForDescriptor.writeDescriptorForIdentifier(
          descriptor, Uint8List.fromList([1, 2, 3, 4]), argThat(isNotNull)),
    );
  });
}
