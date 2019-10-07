part of internal;

class SimulationManager extends SimulationManagerBaseWithErrorChecks
    with ClientManagingMixin, ErrorChecksMixin, PeripheralConnectionMixin, PeripheralScanningMixing {
  SimulationManager(DartToPlatformBridge bridge) : super(bridge);

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    SimulatedPeripheral mapEntry =
        _peripherals.putIfAbsent(peripheral.id, () => peripheral);

    if (!identical(mapEntry, peripheral)) {
      print("Peripheral not added - there already"
          " exists a peripheral with the same id!");
    }
  }

  void removeAllSimulatedPeripherals() {
    _peripherals.clear();
    //TODO notify bridge?
  }

  Future<SimulatedCharacteristic> _readCharacteristicForIdentifier(
    int characteristicIdentifier,
  ) {
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

    return targetCharacteristic.read().then(
          (value) => targetCharacteristic..value = value,
        );
  }

  Future<SimulatedCharacteristic> _readCharacteristicForDevice(
    String peripheralId,
    String serviceUuid,
    String characteristicUUID,
  ) {
    SimulatedPeripheral targetPeripheral =
        _peripherals.values.firstWhere((peripheral) => peripheral.id == peripheralId);

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

    return targetCharacteristic.read().then(
          (value) => targetCharacteristic..value = value,
        );
  }

  Future<SimulatedCharacteristic> _readCharacteristicForService(
    int serviceIdentifier,
    String characteristicUUID,
  ) {
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

    return targetCharacteristic.read().then(
          (value) => targetCharacteristic..value = value,
        );
  }
}
