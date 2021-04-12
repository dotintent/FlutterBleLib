part of _internal;

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
          .invokeMethod<String>(
            MethodName.readCharacteristicForIdentifier,
            <String, dynamic>{
              ArgumentName.characteristicIdentifier: characteristicIdentifier,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) async =>
            throw BleError.fromJson(jsonDecode(errorJson.details))
          )
          .then((rawValue) {
            if (rawValue == null) {
              return Uint8List.fromList([]);
            }
            return _parseCharacteristicWithValueWithTransactionIdResponse(
              peripheral, 
              rawValue
            ).value;
          });

  Future<CharacteristicWithValue> readCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUuid,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod<String>(
            MethodName.readCharacteristicForDevice,
            <String, dynamic>{
              ArgumentName.deviceIdentifier: peripheral.identifier,
              ArgumentName.serviceUuid: serviceUuid,
              ArgumentName.characteristicUuid: characteristicUuid,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) async =>
              throw BleError.fromJson(jsonDecode(errorJson.details))
          )
          .then((rawValue) {
            if (rawValue == null) {
              throw Exception("rawValue cannot be null");
            }
            return _parseCharacteristicWithValueWithTransactionIdResponse(
              peripheral, 
              rawValue
            );
          });

  Future<CharacteristicWithValue> readCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUuid,
    String transactionId,
  ) =>
      _methodChannel
          .invokeMethod<String>(
            MethodName.readCharacteristicForService,
            <String, dynamic>{
              ArgumentName.serviceIdentifier: serviceIdentifier,
              ArgumentName.characteristicUuid: characteristicUuid,
              ArgumentName.transactionId: transactionId
            },
          )
          .catchError((errorJson) =>
            throw BleError.fromJson(jsonDecode(errorJson.details))
          )
          .then((rawValue) {
            if (rawValue == null) {
              throw Exception("rawValue cannot be null");
            }
            return _parseCharacteristicWithValueWithTransactionIdResponse(
              peripheral, 
              rawValue
            );
          });

  Future<Characteristic?> writeCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    Uint8List value,
    bool withResponse,
    String transactionId,
  ) async {
    final inv = _methodChannel.invokeMethod<String>(
      MethodName.writeCharacteristicForIdentifier,
      <String, dynamic>{
        ArgumentName.characteristicIdentifier: characteristicIdentifier,
        ArgumentName.value: value,
        ArgumentName.withResponse: withResponse,
        ArgumentName.transactionId: transactionId,
      },
    ).catchError((errorJson) =>
      throw BleError.fromJson(jsonDecode(errorJson.details))
    ).then((rawJsonValue) {
      if (withResponse == false) {
        return null;
      }
      if (rawJsonValue == null) {
        return null;
      }
      return _parseCharacteristicResponse(peripheral, rawJsonValue);
    });
    if (withResponse == false) {
      return null;
    }
    return await inv;
  }



  Future<Characteristic?> writeCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUuid,
    Uint8List value,
    bool withResponse,
    String transactionId
  ) async {
    final inv = _methodChannel.invokeMethod<String>(
      MethodName.writeCharacteristicForDevice,
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheral.identifier,
        ArgumentName.serviceUuid: serviceUuid,
        ArgumentName.characteristicUuid: characteristicUuid,
        ArgumentName.value: value,
        ArgumentName.withResponse: withResponse,
        ArgumentName.transactionId: transactionId,
      },
    )
    .catchError((errorJson) async =>
      throw BleError.fromJson(jsonDecode(errorJson.details))
    )
    .then((rawJsonValue) {
      if (withResponse == false) {
        return null;
      }
      if (rawJsonValue == null) {
        return null;
      }
      return _parseCharacteristicResponse(peripheral, rawJsonValue);
    });
    if (withResponse == false) {
      return null;
    }
    return await inv;
  }

  Future<Characteristic?> writeCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUuid,
    Uint8List value,
    bool withResponse,
    String transactionId,
  ) async {
    final inv = _methodChannel.invokeMethod(
      MethodName.writeCharacteristicForService,
      <String, dynamic>{
        ArgumentName.serviceIdentifier: serviceIdentifier,
        ArgumentName.characteristicUuid: characteristicUuid,
        ArgumentName.value: value,
        ArgumentName.withResponse: withResponse,
        ArgumentName.transactionId: transactionId,
      },
    )
    .catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))))
    .then((rawJsonValue) {
      if (withResponse == false) {
        return null;
      }
      if (rawJsonValue == null) {
        return null;
      }
      return _parseCharacteristicResponse(peripheral, rawJsonValue);
    });
    if (withResponse == false) {
      return null;
    }
    return await inv;
  }

  Stream<Uint8List> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) {
    void Function() startMonitoring = () => _methodChannel.invokeMethod(
          MethodName.monitorCharacteristicForIdentifier,
          <String, dynamic>{
            ArgumentName.characteristicIdentifier: characteristicIdentifier,
            ArgumentName.transactionId: transactionId,
          },
        );

    bool characteristicFilter(
      CharacteristicWithValueAndTransactionId characteristic,
    ) {
      if (characteristic._id != characteristicIdentifier) {
        return false;
      }
      return equalsIgnoreAsciiCase(
        transactionId,
        characteristic._transactionId ?? "",
      );
    };

    return _createMonitoringStream(
      startMonitoring,
      characteristicFilter,
      peripheral,
      transactionId,
    ).map((characteristicWithValue) => characteristicWithValue.value);
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUuid,
    String transactionId,
  ) {
    void Function() startMonitoring = () => _methodChannel.invokeMethod(
          MethodName.monitorCharacteristicForDevice,
          <String, dynamic>{
            ArgumentName.deviceIdentifier: peripheral.identifier,
            ArgumentName.serviceUuid: serviceUuid,
            ArgumentName.characteristicUuid: characteristicUuid,
            ArgumentName.transactionId: transactionId,
          },
        );

    bool Function(CharacteristicWithValueAndTransactionId)
        characteristicsFilter = (characteristic) =>
            equalsIgnoreAsciiCase(characteristicUuid, characteristic.uuid) &&
            equalsIgnoreAsciiCase(serviceUuid, characteristic.service.uuid) &&
            equalsIgnoreAsciiCase(
                transactionId, characteristic._transactionId ?? "");

    return _createMonitoringStream(
      startMonitoring,
      characteristicsFilter,
      peripheral,
      transactionId,
    );
  }

  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUuid,
    String transactionId,
  ) {
    void Function() startMonitoring = () => _methodChannel.invokeMethod(
          MethodName.monitorCharacteristicForService,
          <String, dynamic>{
            ArgumentName.serviceIdentifier: serviceIdentifier,
            ArgumentName.characteristicUuid: characteristicUuid,
            ArgumentName.transactionId: transactionId,
          },
        );

    bool Function(CharacteristicWithValueAndTransactionId)
        characteristicFilter = (characteristic) =>
            equalsIgnoreAsciiCase(characteristicUuid, characteristic.uuid) &&
            serviceIdentifier == characteristic.service._id &&
            equalsIgnoreAsciiCase(
                transactionId, characteristic._transactionId ?? "");

    return _createMonitoringStream(
      startMonitoring,
      characteristicFilter,
      peripheral,
      transactionId,
    );
  }

  Stream<CharacteristicWithValueAndTransactionId> _createMonitoringStream(
    void Function() onListen,
    bool Function(CharacteristicWithValueAndTransactionId) filter,
    Peripheral peripheral,
    String transactionId,
  ) {
    Stream<CharacteristicWithValueAndTransactionId> stream =
      _characteristicsMonitoringEvents
        .map((rawValue) {
          String rawJsonValue = "";
          if (rawValue is String) {
            rawJsonValue = rawValue;
          }
          return _parseCharacteristicWithValueWithTransactionIdResponse(
            peripheral, 
            rawJsonValue
          );
        })
        .where(filter)
        .handleError((errorJson) =>
            _throwErrorIfMatchesWithTransactionId(errorJson, transactionId))
        .transform<CharacteristicWithValueAndTransactionId>(
          CancelOnErrorStreamTransformer()
        );

    StreamController<CharacteristicWithValueAndTransactionId> streamController =
        StreamController.broadcast(
      onListen: onListen,
      onCancel: () => cancelTransaction(transactionId),
    );

    streamController
        .addStream(stream, cancelOnError: true)
        .then((_) => streamController.close());

    return streamController.stream;
  }

  CharacteristicWithValueAndTransactionId
      _parseCharacteristicWithValueWithTransactionIdResponse(
          Peripheral peripheral, String rawJsonValue) {
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

  void _throwErrorIfMatchesWithTransactionId(PlatformException errorJson, String transactionId) {
    if (errorJson is PlatformException == false) {
      return;
    }
    final errorDetails = jsonDecode(errorJson.details);
    if (transactionId != errorDetails["transactionId"]) {
      return;
    }
    throw BleError.fromJson(errorDetails);
  }
}

class CharacteristicWithValueAndTransactionId extends CharacteristicWithValue {
  String? _transactionId;

  CharacteristicWithValueAndTransactionId.fromJson(
    Map<String, dynamic> jsonObject,
    Service service,
    ManagerForCharacteristic manager,
  ) : super.fromJson(jsonObject, service, manager);

  CharacteristicWithValueAndTransactionId setTransactionId(
      String transactionId) {
    _transactionId = transactionId;
    return this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CharacteristicWithValueAndTransactionId &&
          runtimeType == other.runtimeType &&
          _transactionId == other._transactionId;

  @override
  int get hashCode => super.hashCode ^ _transactionId.hashCode;

  @override
  String toString() =>
      super.toString() +
      ' CharacteristicWithValueAndTransactionId{transactionId: $_transactionId}';
}
