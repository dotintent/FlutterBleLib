import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/mocks.dart';
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

  test(
      "read invokes manager with expected params when transactionId is specified",
      () {
    //when
    descriptor.read(transactionId: "456");

    //then
    verify(
      managerForDescriptor.readDescriptorForIdentifier(descriptor, "456"),
    );
  });

  test(
      "read invokes manager with expected params when transactionId is not specified",
      () {
    //when
    descriptor.read(transactionId: null);

    //then
    verify(
      managerForDescriptor.readDescriptorForIdentifier(
          descriptor, argThat(isNotNull)),
    );
  });

  test(
      "write invokes manager with expected params when transactionId is specified",
      () {
    //when
    descriptor.write(Uint8List.fromList([1, 2, 3, 4]), transactionId: "456");

    //then
    verify(
      managerForDescriptor.writeDescriptorForIdentifier(
          descriptor, Uint8List.fromList([1, 2, 3, 4]), "456"),
    );
  });

  test(
      "write invokes manager with expected params when transactionId is not specified",
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
