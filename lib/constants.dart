part of flutter_ble_lib;

class MethodName {
  static const String CREATE_CLIENT = "createClient";
  static const String DESTROY_CLIENT = "destroyClient";
  static const String START_DEVICE_SCAN = "startDeviceScan";
  static const String STOP_DEVICE_SCAN = "stopDeviceScan";
}

class ChannelName {
  static const String FLUTTER_BLE_LIB = "flutter_ble_lib";
  static const String STATE_RESTORE_EVENTS =
      FLUTTER_BLE_LIB + "/stateRestoreEvents";
  static const String SCANNING_EVENTS = FLUTTER_BLE_LIB + "/scanningEvents";
}

class ArgumentName {
  static const String RESTORE_STATE_IDENTIFIER = "restoreStateIdentifier";
  static const String SCAN_MODE = "scanMode";
  static const String CALLBACK_TYPE = "callbackType";
  static const String UUIDS = "uuids";
}

abstract class ScanMode {
  static const int OPPORTUNISTIC = -1;
  static const int LOW_POWER = 0;
  static const int BALANCED = 1;
  static const int LOW_LATENCY = 2;
}

abstract class CallbackType {
  static const int ALL_MATCHES = 1;
  static const int FIRST_MATCH = 2;
  static const int MATCH_LOST = 4;
}
