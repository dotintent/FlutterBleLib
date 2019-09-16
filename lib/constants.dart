part of flutter_ble_lib;

class MethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";
  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";
}

class ChannelName {
  static const String flutterBleLib = "flutter_ble_lib";
  static const String stateRestoreEvents =
      flutterBleLib + "/stateRestoreEvents";
  static const String scanningEvents = flutterBleLib + "/scanningEvents";
}

class ArgumentName {
  static const String restoreStateIdentifier = "restoreStateIdentifier";
  static const String scanMode = "scanMode";
  static const String callbackType = "callbackType";
  static const String uuids = "uuids";
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
