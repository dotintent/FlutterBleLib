part of flutter_ble_lib;

typedef RestoreStateAction = Function(List<Peripheral> restoreStateIdentifier);

enum LogLevel { none, verbose, debug, info, warning, error }

abstract class BleManager {
  static BleManager _instance;

  factory BleManager() {
    if (_instance == null) {
      _instance = InternalBleManager();
    }

    return _instance;
  }

  Future<void> cancelTransaction(String transactionId);

  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  });

  Future<void> destroyClient();

  Stream<ScanResult> startPeripheralScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
    bool allowDuplicates = false,
  });

  Future<void> stopDeviceScan();

  Future<void> setLogLevel(LogLevel logLevel);

  Future<LogLevel> logLevel();

  Future<void> enableRadio({String transactionId});

  Future<void> disableRadio({String transactionId});

  Future<BluetoothState> bluetoothState();

  Stream<BluetoothState> observeBluetoothState({bool emitCurrentValue = true});

  Future<List<Peripheral>> knownDevices(List<String> peripheralIdentifiers);

  Future<List<Peripheral>> connectedDevices(List<String> serviceUUIDs);
}

enum BluetoothState {
  UNKNOWN,
  UNSUPPORTED,
  UNAUTHORIZED,
  POWERED_ON,
  POWERED_OFF,
  RESETTING,
}

abstract class ScanMode {
  static const int opportunistic = -1;
  static const int lowPower = 0;
  static const int balanced = 1;
  static const int lowLatency = 2;
}

abstract class CallbackType {
  static const int allMatches = 1;
  static const int firstMatch = 2;
  static const int matchLost = 4;
}