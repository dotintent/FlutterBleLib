import 'dart:convert';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';

class CharacteristicGenerator {
  ManagerForCharacteristic managerForCharacteristic;

  CharacteristicGenerator(this.managerForCharacteristic);

  Map<dynamic, dynamic> _createRawCharacteristic(int seed) => <String, dynamic>{
        "characteristicUuid": seed.toString(),
        "id": seed,
        "isReadable": seed % 2 == 0,
        "isWritableWithResponse": seed % 2 == 0,
        "isWritableWithoutResponse": seed % 2 == 0,
        "isNotifiable": seed % 2 == 0,
        "isIndicatable": seed % 2 == 0,
        "value": base64Encode([seed])
      };

  CharacteristicWithValue create(int seed, Service service) =>
      CharacteristicWithValue.fromJson(
        _createRawCharacteristic(seed),
        service,
        managerForCharacteristic,
      );
}
