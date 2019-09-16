part of flutter_ble_lib;

typedef RestoreStateAction = Function(List<Peripheral> restoreStateIdentifier);

class BleManager {
  FlutterBleLib _bleLib;

  BleManager() {
    _bleLib = FlutterBleLib();
  }

  Future<void> createClient(
      {String restoreStateIdentifier, RestoreStateAction restoreStateAction}) {
    if (restoreStateAction != null) {
      _bleLib.restoredState().then((devices) {
        restoreStateAction(devices);
      });
    }
    return _bleLib.createClient(restoreStateIdentifier);
  }

  Future<void> destroyClient() => _bleLib.destroyClient();

  Stream<ScanResult> startDeviceScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
  }) => _bleLib.startDeviceScan(scanMode, callbackType, uuids);

  Future<void> stopDeviceScan() => _bleLib.stopDeviceScan();
}
