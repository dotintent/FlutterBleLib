part of internal;

class SimulationManager {
  List<SimulatedPeripheral> _peripherals = [];
  List<StreamSubscription> _scanSubscriptions = [];
  BlemulatorBridge _bridge;

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
      _scanSubscriptions.add(peripheral
          .onScan(allowDuplicates: true)
          .listen((scanResult) {
            print(scanResult);
            return _bridge.addScanResult(scanResult);
          }));
    });
  }

  Future<void> _stopDeviceScan() async {
    _scanSubscriptions.forEach((subscription) => subscription.cancel());
    _scanSubscriptions.clear();
  }
}
