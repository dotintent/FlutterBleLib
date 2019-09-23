
abstract class MethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";

  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";

  static const String connectToDevice = "connectToDevice";
  static const String isDeviceConnected = "isDeviceConnected";
  static const String observeConnectionState = "observeConnectionState";
  static const String cancelConnection = "cancelConnection";

  static const String discoverAllServicesAndCharacteristics =
      "discoverAllServicesAndCharacteristics";
  static const String services = "services";
  static const String characteristics = "characteristics";
  static const String characteristicsForService = "characteristicsForService";
  static const String setLogLevel = "setLogLevel";
  static const String logLevel = "logLevel";
}

abstract class ChannelName {
  static const String flutterBleLib = "flutter_ble_lib";
  static const String stateRestoreEvents =
      flutterBleLib + "/stateRestoreEvents";
  static const String scanningEvents = flutterBleLib + "/scanningEvents";
  static const String connectionStateChangeEvents =
      flutterBleLib + "/connectionStateChangeEvents";
}

abstract class ArgumentName {
  static const String restoreStateIdentifier = "restoreStateIdentifier";
  static const String scanMode = "scanMode";
  static const String callbackType = "callbackType";
  static const String uuids = "uuids";

  static const String transactionId = "transactionId";

  static const String deviceIdentifier = "deviceIdentifier";
  static const String isAutoConnect = "isAutoConnect";
  static const String requestMtu = "requestMtu";
  static const String refreshGatt = "refreshGatt";
  static const String timeoutMillis = "timeoutMillis";
  static const String emitCurrentValue = "emitCurrentValue";

  static const String serviceUuid = "serviceUuid";
  static const String serviceId = "serviceId";

  static const String logLevel = "logLevel";
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

abstract class NativeConnectionState {
  static const String connecting = "connecting";
  static const String connected = "connected";
  static const String disconnecting = "disconnecting";
  static const String disconnected = "disconnected";
}
