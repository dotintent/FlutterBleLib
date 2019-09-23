part of flutter_ble_lib;

mixin CharacteristicsMixin on FlutterBLE {
  Future<CharacteristicWithValue> readCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier, {
    String transactionId,
  }) =>
      _methodChannel.invokeMethod(
        MethodName.readCharacteristicForIdentifier,
        <String, dynamic>{
          ArgumentName.characteristicIdentifier: characteristicIdentifier,
          ArgumentName.transactionId: transactionId
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });

  Future<CharacteristicWithValue> readCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _methodChannel.invokeMethod(
        MethodName.readCharacteristicForDevice,
        <String, dynamic>{
          ArgumentName.deviceIdentifier: peripheral.identifier,
          ArgumentName.serviceUuid: serviceUuid,
          ArgumentName.characteristicUuid: characteristicUUID,
          ArgumentName.transactionId: transactionId
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });

  Future<CharacteristicWithValue> readCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _methodChannel.invokeMethod(
        MethodName.readCharacteristicForService,
        <String, dynamic>{
          ArgumentName.serviceId: serviceIdentifier,
          ArgumentName.characteristicUuid: characteristicUUID,
          ArgumentName.transactionId: transactionId
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });

  Future<Characteristic> writeCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _methodChannel.invokeMethod(
        MethodName.writeCharacteristicForIdentifier,
        <String, dynamic>{
          ArgumentName.characteristicIdentifier: characteristicIdentifier,
          ArgumentName.bytes: bytes,
          ArgumentName.withResponse: withResponse,
          ArgumentName.transactionId: transactionId,
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });

  Future<Characteristic> writeCharacteristicForDevice(
          Peripheral peripheral,
          String serviceUUID,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          {String transactionId}) =>
      _methodChannel.invokeMethod(
        MethodName.writeCharacteristicForDevice,
        <String, dynamic>{
          ArgumentName.deviceIdentifier: peripheral.identifier,
          ArgumentName.serviceUuid: serviceUUID,
          ArgumentName.characteristicUuid: characteristicUUID,
          ArgumentName.bytes: bytes,
          ArgumentName.withResponse: withResponse,
          ArgumentName.transactionId: transactionId,
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });

  Future<Characteristic> writeCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _methodChannel.invokeMethod(
        MethodName.writeCharacteristicForService,
        <String, dynamic>{
          ArgumentName.serviceId: serviceIdentifier,
          ArgumentName.characteristicUuid: characteristicUUID,
          ArgumentName.bytes: bytes,
          ArgumentName.withResponse: withResponse,
          ArgumentName.transactionId: transactionId,
        },
      ).then((rawJsonValue) {
        Service service = Service.fromJson(rawJsonValue, peripheral, _manager);
        return CharacteristicWithValue.fromJson(rawJsonValue, service);
      });
}
