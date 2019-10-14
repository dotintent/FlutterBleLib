part of internal;

mixin CharacteristicsMixin on SimulationManagerBase {
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

      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break peripheralsLoop;
      }
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

    await targetCharacteristic.write(value);
    return targetCharacteristic;
  }

  Future<void> _monitorCharacteristicForIdentifier(
    int characteristicIdentifier,
    String transactionId,
  ) async {
    SimulatedCharacteristic targetCharacteristic =
        getCharacteristic(characteristicIdentifier);

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

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
    SimulatedPeripheral targetPeripheral = _peripherals.values
        .firstWhere((peripheral) => peripheral.id == peripheralId);

    SimulatedCharacteristic targetCharacteristic = targetPeripheral
        .getCharacteristicForService(serviceUuid, characteristicUUID);

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

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

    if (targetCharacteristic == null)
      return Future.error("Characteristic not found");

    _monitoringSubscriptions.putIfAbsent(
      transactionId,
      () => targetCharacteristic.monitor().listen((value) {
        _bridge.publishCharacteristicUpdate(targetCharacteristic, value);
      }),
    );
  }

  _cancelMonitoringTransactionIfExists(String transactionId) async {
    _monitoringSubscriptions.remove(transactionId)?.cancel();
  }
}
