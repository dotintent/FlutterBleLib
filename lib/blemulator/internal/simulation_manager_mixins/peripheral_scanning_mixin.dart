part of internal;

mixin PeripheralScanningMixing on SimulationManagerBase {
  List<StreamSubscription> _scanSubscriptions = [];

  Future<void> _startDeviceScan() async {
    _peripherals.values.forEach((peripheral) {
      _scanSubscriptions.add(
          peripheral.onScan(allowDuplicates: true).listen((scanResult) async {
        print(scanResult);
        await _bridge.publishScanResult(scanResult);
      }));
    });
  }

  Future<void> _stopDeviceScan() async {
    _scanSubscriptions.forEach((subscription) => subscription.cancel());
    _scanSubscriptions.clear();
  }
}
