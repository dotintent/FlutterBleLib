part of internal;

class SimulationManager extends SimulationManagerBaseWithErrorChecks
    with
        ClientManagingMixin,
        CharacteristicsMixin,
        ErrorChecksMixin,
        PeripheralConnectionMixin,
        PeripheralScanningMixing,
        DiscoveryMixin {
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

  Future<void> _createClient() async {
    print("entered create client");
  }

  Future<void> _destroyClient() async {}

  Future<void> _startDeviceScan() async {
    _peripherals.forEach((peripheral) {
      _scanSubscriptions
          .add(peripheral.onScan(allowDuplicates: true).listen((scanResult) {
        print(scanResult);
        return _bridge.publishScanResult(scanResult);
      }));
    });
  }

  Future<void> _stopDeviceScan() async {
    _scanSubscriptions.forEach((subscription) => subscription.cancel());
    _scanSubscriptions.clear();
  }

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
