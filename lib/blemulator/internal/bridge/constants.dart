part of internal;

abstract class ChannelName {
  static const String _base = "com.polidea.blemulator";
  static const String platformToDart = "$_base/toDart";
  static const String dartToPlatform = "$_base/toJava";
}

abstract class PlatformMethodName {
  static const String simulate = "simulate";
}

abstract class SimulationPlatformMethodName {
  static const String publishScanResult = "publishScanResult";
  static const String publishConnectionState = "publishConnectionState";
}

abstract class DartMethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";

  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";

  static const String connectToPeripheral = "connectToDevice";
  static const String isPeripheralConnected = "isDeviceConnected";
  static const String disconnectOrCancelConnectionToPeripheral = "disconnectOrCancelConnection";
}

abstract class SimulationArgumentName {
  static const String name = "name";
  static const String id = "id";
  static const String mtu = "mtu";
  static const String rssi = "rssi";
  static const String isConnectable = "isConnectable";
  static const String txPowerLevel = "txPowerLevel";
  static const String manufacturerData = "manufacturerData";
  static const String serviceData = "serviceData";
  static const String serviceUuids = "serviceUuids";
  static const String localName = "localName";
  static const String solicitedServiceUuids = "solicitedServiceUuids";
  static const String overflowUuids = "overflowUuids";

  static const String connectionState = "connectionState";
}

abstract class ArgumentName {
  static const String id = "id";
  static const String emitCurrentValue = "emitCurrentValue";
}