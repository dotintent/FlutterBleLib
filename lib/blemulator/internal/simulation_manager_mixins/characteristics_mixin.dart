part of internal;

mixin CharacteristicsMixin on SimulationManagerBaseWithErrorChecks {
  Map<String, StreamSubscription> _monitoringSubscriptions = HashMap();

  SimulatedCharacteristic getCharacteristic(int characteristicIdentifier) {
    SimulatedCharacteristic targetCharacteristic;

    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.getCharacteristicForId(characteristicIdentifier);
      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break;
      }
    }

    return targetCharacteristic;
  }

  Future<CharacteristicResponse> _readCharacteristicForIdentifier(
    int characteristicIdentifier,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        getCharacteristic(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    Uint8List value = await targetCharacteristic.read();
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<CharacteristicResponse> _readCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
  ) async {
    SimulatedPeripheral targetPeripheral = _peripherals.values
        .firstWhere((peripheral) => peripheral.id == peripheralId);

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    Uint8List value = await targetCharacteristic.read();
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<CharacteristicResponse> _readCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
  ) async {
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUUID,
                orElse: () => null,
              );

      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
    }

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    Uint8List value = await targetCharacteristic.read();
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForIdentifier(
    int characteristicIdentifier,
    Uint8List value,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        getCharacteristic(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    await _errorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
    Uint8List value,
  ) async {
    SimulatedPeripheral targetPeripheral = _peripherals.values
        .firstWhere((peripheral) => peripheral.id == peripheralId);

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    await _errorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List value,
  ) async {
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUUID,
                orElse: () => null,
              );

      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
    }

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    await  _errorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    return targetCharacteristic;
  }

  Future<void> _monitorCharacteristicForIdentifier(
    int characteristicIdentifier,
    String transactionId,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        getCharacteristic(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    await _errorIfNotMonitorable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(targetCharacteristic, value);
      }),
    );
  }

  Future<void> _monitorCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  ) async {
    await _errorIfUnknown(peripheralId);
    await _errorIfNotConnected(peripheralId);
    SimulatedPeripheral targetPeripheral = _peripherals.values
        .firstWhere((peripheral) => peripheral.id == peripheralId);

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    await _errorIfNotMonitorable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(targetCharacteristic, value);
      }),
    );
  }

  Future<void> _monitorCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) async {
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUUID,
                orElse: () => null,
              );

      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
    }

    await _errorIfCharacteristicIsNull(targetCharacteristic, characteristicUUID);
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    await _errorIfNotMonitorable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(targetCharacteristic, value);
      }),
    );
  }

  Future<void> _errorIfNotWritable(SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithResponse ||
        !characteristic.isWritableWithoutResponse) {
      return Future.error(SimulatedBleError(
        BleErrorCode.CharacteristicWriteFailed,
        "Characteristic ${characteristic.uuid} is not writeable",
      ));
    }
  }

  Future<void> _errorIfNotMonitorable(SimulatedCharacteristic characteristic) async {
    if (!characteristic.isNotifiable && !characteristic.isIndicatable) {
      return Future.error(SimulatedBleError(
        BleErrorCode.CharacteristicNotifyChangeFailed,
        "Characteristic ${characteristic.uuid} is not monitorable",
      ));
    }
  }

  Future<void> _errorIfCharacteristicIsNull(
    SimulatedCharacteristic characteristic,
    String characteristicId,
  ) async {
    if (characteristic == null) {
      return Future.error(SimulatedBleError(
        BleErrorCode.CharacteristicNotFound,
        "Characteristic $characteristicId not found",
      ));
    }
  }

  Future<void> _cancelMonitoringTransactionIfExists(
      String transactionId) async {
    await _monitoringSubscriptions.remove(transactionId)?.cancel();
  }
}
