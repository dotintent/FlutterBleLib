part of flutter_ble_lib;

class InternalBleManager implements BleManager, PeripheralManager {
  FlutterBleLib _bleLib;

  InternalBleManager() {
    _bleLib = FlutterBleLib();
    _bleLib.registerManager(this);
  }

  @override
  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  }) {
    if (restoreStateAction != null) {
      _bleLib.restoredState().then((devices) {
        restoreStateAction(devices);
      });
    }
    return _bleLib.createClient(restoreStateIdentifier);
  }

  @override
  Future<void> destroyClient() => _bleLib.destroyClient();

  @override
  Stream<ScanResult> startDeviceScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
  }) =>
      _bleLib.startDeviceScan(scanMode, callbackType, uuids);

  @override
  Future<void> stopDeviceScan() => _bleLib.stopDeviceScan();

  @override
  Future<void> connectToPeripheral(String identifier,
          {bool isAutoConnect,
          int requestMtu,
          bool refreshGatt,
          Duration timeout}) async =>
      _bleLib.connectToPeripheral(
          identifier, isAutoConnect, requestMtu, refreshGatt, timeout);

  @override
  Stream<PeripheralConnectionState> observePeripheralConnectionState(
          String peripheralIdentifier, bool emitCurrentValue) =>
      _bleLib.observePeripheralConnectionState(
          peripheralIdentifier, emitCurrentValue);

  @override
  Future<void> disconnectOrCancelPeripheralConnection(
          String peripheralIdentifier) =>
      _bleLib.disconnectOrCancelPeripheralConnection(peripheralIdentifier);

  @override
  Future<bool> isPeripheralConnected(String peripheralIdentifier) =>
      _bleLib.isPeripheralConnected(peripheralIdentifier);
}
