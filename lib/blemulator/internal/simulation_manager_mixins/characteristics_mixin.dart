part of internal;

mixin CharacteristicsMixin on SimulationManagerBaseWithErrorChecks {
  Future<SimulatedCharacteristic> _getCharacteristic(
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

  Future<CharacteristicResponse> _readCharacteristicForIdentifier(
    int characteristicIdentifier,
  ) async {
    SimulatedPeripheral peripheral =
        _peripheralWithCharacteristicId(characteristicIdentifier);
    await _errorIfPeripheralNull(peripheral);
    await _errorIfNotConnected(peripheral.id);

    SimulatedCharacteristic targetCharacteristic =
        await _getCharacteristic(characteristicIdentifier);

    await _throwErrorIfNull(
        targetCharacteristic, characteristicIdentifier.toString());

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

    SimulatedPeripheral targetPeripheral =_peripherals[peripheralId];

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _throwErrorIfNull(targetCharacteristic, characteristicUUID);
    Uint8List value = await targetCharacteristic.read();
    await _errorIfDisconnected(peripheralId);
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<CharacteristicResponse> _readCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
  ) async {
    SimulatedCharacteristic targetCharacteristic;
    String peripheralId;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUUID,
                orElse: () => null,
              );

      if (characteristic != null) {
        peripheralId = peripheral.id;
        await _errorIfNotConnected(peripheralId);
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
    }

    await _throwErrorIfNull(targetCharacteristic, characteristicUUID);
    Uint8List value = await targetCharacteristic.read();
    await _errorIfDisconnected(peripheralId);
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForIdentifier(
    int characteristicIdentifier,
    Uint8List value,
  ) async {
    SimulatedPeripheral peripheral =
        _peripheralWithCharacteristicId(characteristicIdentifier);

    await _errorIfPeripheralNull(peripheral);
    await _errorIfNotConnected(peripheral.id);

    SimulatedCharacteristic targetCharacteristic =
        await _getCharacteristic(characteristicIdentifier);

    await _throwErrorIfNull(
        targetCharacteristic, characteristicIdentifier.toString());
    await _throwErrorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    await _errorIfDisconnected(peripheral.id);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
    Uint8List value,
  ) async {
    await _errorIfNotConnected(peripheralId);
    SimulatedPeripheral targetPeripheral = _peripherals[peripheralId];

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    await _throwErrorIfNull(targetCharacteristic, characteristicUUID);
    await _throwErrorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    await _errorIfDisconnected(peripheralId);
    return targetCharacteristic;
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
    Uint8List value,
  ) async {
    String peripheralId;
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      SimulatedCharacteristic characteristic =
          peripheral.service(serviceIdentifier)?.characteristics()?.firstWhere(
                (characteristic) => characteristic.uuid == characteristicUUID,
                orElse: () => null,
              );

      if (characteristic != null) {
        peripheralId = peripheral.id;
        await _errorIfNotConnected(peripheral.id);
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
    }

    await _throwErrorIfNull(targetCharacteristic, characteristicUUID);
    await _throwErrorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    _errorIfDisconnected(peripheralId);
    return targetCharacteristic;
  }

  Future<void> _throwErrorIfNotWritable(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithResponse ||
        !characteristic.isWritableWithoutResponse) {
      return Future.error(SimulatedBleError(
        BleErrorCode.CharacteristicWriteFailed,
        "Characteristic ${characteristic.uuid} is not writeable",
      ));
    }
  }

  Future<void> _throwErrorIfNull(
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
}
