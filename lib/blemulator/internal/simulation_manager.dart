part of internal;

class SimulationManager {
  List<SimulatedPeripheral> _peripherals = [];
  List<StreamSubscription> _scanSubscriptions = [];
  DartToPlatformBridge _bridge;

  SimulationManager(this._bridge);

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    _peripherals.add(peripheral);
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

  Future<SimulatedCharacteristic> _readCharacteristicForIdentifier(
    int characteristicIdentifier,
  ) {
    SimulatedCharacteristic targetCharacteristic;
    peripheralsLoop:
    for (SimulatedPeripheral peripheral in _peripherals) {
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
        _peripherals.firstWhere((peripheral) => peripheral.id == peripheralId);

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
    for (SimulatedPeripheral peripheral in _peripherals) {
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
