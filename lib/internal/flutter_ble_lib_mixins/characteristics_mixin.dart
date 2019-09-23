part of flutter_ble_lib;

mixin CharacteristicsMixin on FlutterBLE {
  final EventChannel _monitoringChannel =
      const EventChannel(ChannelName.monitorCharacteristic);

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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

  Future<CharacteristicWithValue> writeCharacteristicForIdentifier(
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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

  Future<CharacteristicWithValue> writeCharacteristicForDevice(
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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

  Future<CharacteristicWithValue> writeCharacteristicForService(
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
      ).then(
        (rawJsonValue) =>
            _parseCharacteristicResponse(peripheral, rawJsonValue),
      );

  Stream<CharacteristicWithValue> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier, {
    String transactionId,
  }) async* {
    yield* _monitoringChannel.receiveBroadcastStream().map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        );
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForIdentifier,
      <String, dynamic>{
        ArgumentName.characteristicIdentifier: characteristicIdentifier,
        ArgumentName.transactionId: transactionId,
      },
    );
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID, {
    String transactionId,
  }) async* {
    yield* _monitoringChannel.receiveBroadcastStream().map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        );
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForDevice,
      <String, dynamic>{
        ArgumentName.serviceUuid: serviceUuid,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID, {
    String transactionId,
  }) async* {
    yield* _monitoringChannel.receiveBroadcastStream().map(
          (rawJsonValue) =>
              _parseCharacteristicResponse(peripheral, rawJsonValue),
        );
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForService,
      <String, dynamic>{
        ArgumentName.serviceId: serviceIdentifier,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
  }

  CharacteristicWithValue _parseCharacteristicResponse(
      Peripheral peripheral, rawJsonValue) {
    Map<String, dynamic> rootObject = jsonDecode(rawJsonValue);
    Service service = Service.fromJson(rootObject, peripheral, _manager);

    return CharacteristicWithValue.fromJson(
        rootObject["characteristic"], service);
  }
}
