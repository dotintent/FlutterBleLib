part of internal;

mixin CharacteristicsMixin on SimulationManagerBase {

  Future<CharacteristicResponse> _readCharacteristicForIdentifier(
      int characteristicIdentifier,
      ) async {
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals.values) {
      for (SimulatedService service in peripheral.services()) {
        SimulatedCharacteristic characteristic =
        service.characteristic(characteristicIdentifier);
        if (characteristic != null) {
          targetCharacteristic = characteristic;
          break peripheralsLoop;
        }
      }
    }

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
        .services()
        .firstWhere(
          (service) => service.uuid == serviceUuid,
      orElse: () => null,
    )
        ?.characteristics()
        ?.firstWhere(
          (characteristic) => characteristic.uuid == characteristicUUID,
      orElse: () => null,
    );

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
}