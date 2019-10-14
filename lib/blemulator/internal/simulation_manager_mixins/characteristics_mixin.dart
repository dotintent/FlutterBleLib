part of internal;

mixin CharacteristicsMixin on SimulationManagerBase {
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

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

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

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

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

      if (characteristic != null) break peripheralsLoop;
    }

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

    Uint8List value = await targetCharacteristic.read();
    return CharacteristicResponse(targetCharacteristic, value);
  }

  Future<SimulatedCharacteristic> _writeCharacteristicForIdentifier(
    int characteristicIdentifier,
    Uint8List value,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        getCharacteristic(characteristicIdentifier);

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

    _throwErrorIfNotWritable(targetCharacteristic);
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

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

    _throwErrorIfNotWritable(targetCharacteristic);
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

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

    _throwErrorIfNotWritable(targetCharacteristic);
    await targetCharacteristic.write(value);
    return targetCharacteristic;
  }

  _throwErrorIfNotWritable(SimulatedCharacteristic characteristic) {
    if (!characteristic.isWritableWithResponse ||
        !characteristic.isWritableWithoutResponse) {
      throw Future.error(SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed,
          "Characteristic ${characteristic.uuid} is not writeable"));
    }
  }
}
