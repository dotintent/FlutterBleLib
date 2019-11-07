part of internal_bridge_lib;

mixin CharacteristicsMixin on FlutterBLE {
  final Stream<dynamic> _characteristicsMonitoringEvents =
      const EventChannel(ChannelName.monitorCharacteristic)
          .receiveBroadcastStream();

  Future<Uint8List> readCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForIdentifier,
            <String, dynamic>{
              ArgumentName.characteristicIdentifier: characteristicIdentifier,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then((rawJsonValue) =>
              _parseCharacteristicWithValueWithTransactionIdResponse(
                      peripheral, rawJsonValue)
                  .value);

  Future<CharacteristicWithValue> readCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForDevice,
            <String, dynamic>{
              ArgumentName.deviceIdentifier: peripheral.identifier,
              ArgumentName.serviceUuid: serviceUuid,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicWithValueWithTransactionIdResponse(
                    peripheral, rawJsonValue),
          );

  Future<CharacteristicWithValue> readCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.readCharacteristicForService,
            <String, dynamic>{
              ArgumentName.serviceIdentifier: serviceIdentifier,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicWithValueWithTransactionIdResponse(
                    peripheral, rawJsonValue),
          );

  Future<void> writeCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  ) =>
      _methodChannel.invokeMethod(
        MethodName.writeCharacteristicForIdentifier,
        <String, dynamic>{
          ArgumentName.characteristicIdentifier: characteristicIdentifier,
          ArgumentName.value: bytes,
          ArgumentName.withResponse: withResponse,
          ArgumentName.transactionId: transactionId,
        },
      ).catchError((errorJson) =>
          Future.error(BleError.fromJson(jsonDecode(errorJson.details))));

  Future<Characteristic> writeCharacteristicForDevice(
          Peripheral peripheral,
          String serviceUUID,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _methodChannel
          .invokeMethod(
            MethodName.writeCharacteristicForDevice,
            <String, dynamic>{
              ArgumentName.deviceIdentifier: peripheral.identifier,
              ArgumentName.serviceUuid: serviceUUID,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.value: bytes,
              ArgumentName.withResponse: withResponse,
              ArgumentName.transactionId: transactionId,
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Future<Characteristic> writeCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod(
            MethodName.writeCharacteristicForService,
            <String, dynamic>{
              ArgumentName.serviceIdentifier: serviceIdentifier,
              ArgumentName.characteristicUuid: characteristicUUID,
              ArgumentName.value: bytes,
              ArgumentName.withResponse: withResponse,
              ArgumentName.transactionId: transactionId,
            },
          )
          .catchError((errorJson) =>
              Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
          .then(
            (rawJsonValue) =>
                _parseCharacteristicResponse(peripheral, rawJsonValue),
          );

  Stream<Uint8List> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForIdentifier,
      <String, dynamic>{
        ArgumentName.characteristicIdentifier: characteristicIdentifier,
        ArgumentName.transactionId: transactionId,
      },
    );
    return _characteristicsMonitoringEvents
        .map(
          (rawJsonValue) =>
              _parseCharacteristicWithValueWithTransactionIdResponse(
                  peripheral, rawJsonValue),
        )
        .where(
          (characteristic) =>
              characteristic._id == characteristicIdentifier &&
              equalsIgnoreAsciiCase(
                  transactionId ?? "", characteristic.transactionId ?? ""),
        )
        .map((characteristicWithValue) => characteristicWithValue.value)
        .transform(CancelOnErrorStreamTransformer())
        .handleError((errorJson) =>
            _throwErrorIfMatchesWithTransactionId(errorJson, transactionId));
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  ) {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForDevice,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.serviceUuid: serviceUuid,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
    return _characteristicsMonitoringEvents
        .map((rawJsonValue) =>
            _parseCharacteristicWithValueWithTransactionIdResponse(
                peripheral, rawJsonValue))
        .where((characteristic) =>
            equalsIgnoreAsciiCase(characteristicUUID, characteristic.uuid) &&
            equalsIgnoreAsciiCase(serviceUuid, characteristic.service.uuid) &&
            equalsIgnoreAsciiCase(
                transactionId ?? "", characteristic.transactionId ?? ""))
        .transform(CancelOnErrorStreamTransformer())
        .handleError((errorJson) =>
            _throwErrorIfMatchesWithTransactionId(errorJson, transactionId));
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) {
    _methodChannel.invokeMethod(
      MethodName.monitorCharacteristicForService,
      <String, dynamic>{
        ArgumentName.serviceIdentifier: serviceIdentifier,
        ArgumentName.characteristicUuid: characteristicUUID,
        ArgumentName.transactionId: transactionId,
      },
    );
    return _characteristicsMonitoringEvents
        .map(
          (rawJsonValue) =>
              _parseCharacteristicWithValueWithTransactionIdResponse(
                  peripheral, rawJsonValue),
        )
        .where(
          (characteristic) =>
              equalsIgnoreAsciiCase(characteristicUUID, characteristic.uuid) &&
              serviceIdentifier == characteristic.service._id &&
              equalsIgnoreAsciiCase(
                  transactionId ?? "", characteristic.transactionId ?? ""),
        )
        .transform(CancelOnErrorStreamTransformer())
        .handleError((errorJson) =>
            _throwErrorIfMatchesWithTransactionId(errorJson, transactionId));
  }

  CharacteristicWithValueAndTransactionId
      _parseCharacteristicWithValueWithTransactionIdResponse(
          Peripheral peripheral, rawJsonValue) {
    Map<String, dynamic> rootObject = jsonDecode(rawJsonValue);
    Service service = Service.fromJson(rootObject, peripheral, _manager);

    var transactionId = rootObject["transactionId"];
    return CharacteristicWithValueAndTransactionId.fromJson(
            rootObject["characteristic"], service, _manager)
        .setTransactionId(transactionId);
  }

  Characteristic _parseCharacteristicResponse(
      Peripheral peripheral, rawJsonValue) {
    Map<String, dynamic> rootObject = jsonDecode(rawJsonValue);
    Service service = Service.fromJson(rootObject, peripheral, _manager);

    return Characteristic.fromJson(
        rootObject["characteristic"], service, _manager);
  }

  void _throwErrorIfMatchesWithTransactionId(errorJson, transactionId) {
    var errorDetails = jsonDecode(errorJson.details);
    if (transactionId == errorDetails["transactionId"])
      throw BleError.fromJson(errorDetails);
    else
      return;
  }
}

class CharacteristicWithValueAndTransactionId extends CharacteristicWithValue {
  String transactionId;

  CharacteristicWithValueAndTransactionId.fromJson(
    Map<String, dynamic> jsonObject,
    Service service,
    ManagerForCharacteristic manager,
  ) : super.fromJson(jsonObject, service, manager);

  CharacteristicWithValueAndTransactionId setTransactionId(
      String transactionId) {
    this.transactionId = transactionId;
    return this;
  }
}
