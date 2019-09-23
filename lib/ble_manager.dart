part of flutter_ble_lib;

typedef RestoreStateAction = Function(List<Peripheral> restoreStateIdentifier);


abstract class BleManager {
  static BleManager _instance;

  static BleManager getInstance() {
    if (_instance == null) {
      _instance = InternalBleManager();
    }

    return _instance;
  }

  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  });

  Future<void> destroyClient();

  Stream<ScanResult> startPeripheralScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
  });

  Future<void> stopDeviceScan();

  Future<void> setLogLevel(LogLevel logLevel);
  Future<LogLevel> logLevel();
}
