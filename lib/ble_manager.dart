part of flutter_ble_lib;

typedef RestoreStateAction = Function(List<Peripheral> restoreStateIdentifier);

enum LogLevel { NONE, VERBOSE, DEBUG, INFO, WARNING, ERROR }

LogLevel logLevelFromString(String logLevelName) {
  print("try to get log level from: $logLevelName");
  return LogLevel.values.firstWhere((e) => e.toString() == 'LogLevel.' + logLevelName);
}

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
