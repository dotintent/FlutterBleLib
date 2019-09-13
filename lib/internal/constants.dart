part of flutter_ble_lib;

class MethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";
  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";
  static const String CONNECT_TO_DEVICE = "connectToDevice";
  static const String IS_DEVICE_CONNECTED = "isDeviceConnected";
  static const String OBSERVE_CONNECTION_STATE = "observeConnectionState";
  static const String CANCEL_CONNECTION = "cancelConnection";
}

class ChannelName {
  static const String flutterBleLib = "flutter_ble_lib";
  static const String stateRestoreEvents =
      flutterBleLib + "/stateRestoreEvents";
  static const String scanningEvents = flutterBleLib + "/scanningEvents";
  static const String CONNECTION_STATE_CHANGE_EVENTS = flutterBleLib +
      "/connectionStateChangeEvents";
}

class ArgumentName {
  static const String restoreStateIdentifier = "restoreStateIdentifier";
  static const String scanMode = "scanMode";
  static const String callbackType = "callbackType";
  static const String uuids = "uuids";

  static const String DEVICE_IDENTIFIER = "deviceIdentifier";
  static const String IS_AUTO_CONNECT = "isAutoConnect";
  static const String REQUESTU_MTU = "requestMtu";
  static const String REFRESH_GATT = "refreshGatt";
  static const String TIMEOUT_MILLIS = "timeoutMillis";
  static const String EMIT_CURRENT_VALUE = "emitCurrentValue";
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
  static const String CONNECTING = "connecting";
  static const String CONNECTED = "connected";
  static const String DISCONNECTING = "disconnecting";
  static const String DISCONNECTED = "disconnected";
}