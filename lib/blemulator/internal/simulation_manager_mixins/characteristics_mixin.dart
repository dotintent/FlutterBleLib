part of internal;

mixin CharacteristicsMixin on SimulationManagerBaseWithErrorChecks {
  Map<String, StreamSubscription> _monitoringSubscriptions = HashMap();

  Future<SimulatedCharacteristic> _findCharacteristicForId(
      int characteristicIdentifier) async {
    SimulatedCharacteristic targetCharacteristic;

    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.characteristic(characteristicIdentifier);

      if (characteristic != null) {
        await _errorIfNotConnected(peripheral.id);
        targetCharacteristic = characteristic;
        break;
      }
    }

    return targetCharacteristic;
  }

  SimulatedCharacteristic _findCharacteristicForServiceId(
    int serviceIdentifier,
    String characteristicUuid,
  ) {
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUuid,
                orElse: () => null,
              );

      if (characteristic != null) {
        return characteristic;
      }
    }
    return null;
  }

  Future<CharacteristicResponse> _readCharacteristicForIdentifier(
    int characteristicIdentifier,
  ) async {
    SimulatedPeripheral peripheral =
        _peripheralWithCharacteristicId(characteristicIdentifier);
    await _errorIfPeripheralNull(peripheral);
    await _errorIfNotConnected(peripheral.id);

    SimulatedCharacteristic targetCharacteristic =
        await _findCharacteristicForId(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    await _errorIfCharacteristicNotReadable(targetCharacteristic);
    Uint8List value = await targetCharacteristic.read();
    await _errorIfDisconnected(peripheral.id);
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<CharacteristicResponse> _readCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
  ) async {
    await _errorIfNotConnected(peripheralId);

    SimulatedPeripheral targetPeripheral = _peripherals[peripheralId];

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    await _errorIfCharacteristicNotReadable(targetCharacteristic);
    Uint8List value = await targetCharacteristic.read();
    await _errorIfDisconnected(peripheralId);
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<CharacteristicResponse> _readCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        _findCharacteristicForServiceId(serviceIdentifier, characteristicUUID);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    await _errorIfCharacteristicNotReadable(targetCharacteristic);
    Uint8List value = await targetCharacteristic.read();
    await _errorIfDisconnected(targetCharacteristic.service.peripheralId);
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForIdentifier(
    int characteristicIdentifier,
    Uint8List value, {
    bool withResponse = true,
  }) async {
    SimulatedPeripheral peripheral =
        _peripheralWithCharacteristicId(characteristicIdentifier);

    await _errorIfPeripheralNull(peripheral);
    await _errorIfNotConnected(peripheral.id);

    SimulatedCharacteristic targetCharacteristic =
        await _findCharacteristicForId(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    if (withResponse) {
      await _errorIfCharacteristicNotWritableWithResponse(targetCharacteristic);
    } else {
      await _errorIfCharacteristicNotWritableWithoutResponse(
          targetCharacteristic);
    }
    await targetCharacteristic.write(value);
    await _errorIfDisconnected(peripheral.id);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
    Uint8List value, {
    bool withResponse = true,
  }) async {
    await _errorIfNotConnected(peripheralId);
    SimulatedPeripheral targetPeripheral = _peripherals[peripheralId];

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    if (withResponse) {
      await _errorIfCharacteristicNotWritableWithResponse(targetCharacteristic);
    } else {
      await _errorIfCharacteristicNotWritableWithoutResponse(
          targetCharacteristic);
    }
    await targetCharacteristic.write(value);
    await _errorIfDisconnected(peripheralId);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List value, {
    bool withResponse = true,
  }) async {
    SimulatedCharacteristic targetCharacteristic =
        _findCharacteristicForServiceId(serviceIdentifier, characteristicUUID);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    if (withResponse) {
      await _errorIfCharacteristicNotWritableWithResponse(targetCharacteristic);
    } else {
      await _errorIfCharacteristicNotWritableWithoutResponse(
          targetCharacteristic);
    }
    await targetCharacteristic.write(value);
    await _errorIfDisconnected(targetCharacteristic.service.peripheralId);
    return targetCharacteristic;
  }

  Future<void> _monitorCharacteristicForIdentifier(
    int characteristicIdentifier,
    String transactionId,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        await _findCharacteristicForId(characteristicIdentifier);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicIdentifier.toString());
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    await _errorIfCharacteristicNotNotifiable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(
            targetCharacteristic, value, transactionId);
      }, onError: (error) {
        _bridge.publishCharacteristicMonitoringError(
            characteristicIdentifier, error, transactionId);
      }, cancelOnError: true),
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

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    await _errorIfCharacteristicNotNotifiable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(
            targetCharacteristic, value, transactionId);
      }, onError: (error) {
        _bridge.publishCharacteristicMonitoringError(
            targetCharacteristic.id, error, transactionId);
      }, cancelOnError: true),
    );
  }

  Future<void> _monitorCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        _findCharacteristicForServiceId(serviceIdentifier, characteristicUUID);

    await _errorIfCharacteristicIsNull(
        targetCharacteristic, characteristicUUID);
    await _errorIfNotConnected(targetCharacteristic.service.peripheralId);
    await _errorIfCharacteristicNotNotifiable(targetCharacteristic);
    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(
            targetCharacteristic, value, transactionId);
      }, onError: (error) {
        _bridge.publishCharacteristicMonitoringError(
            targetCharacteristic.id, error, transactionId);
      }, cancelOnError: true),
    );
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
