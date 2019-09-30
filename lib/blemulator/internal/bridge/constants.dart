part of internal;

abstract class ChannelName {
  static String _base = "com.polidea.blemulator";
  static String upstream = "$_base/toDart";
  static String downstream = "$_base/toJava";
}

abstract class DownstreamMethodName {
  static String simulate = "simulate";
}

abstract class SimulationDownstreamMethodName {
  static const String publishScanResult = "publishScanResult";
}

abstract class UpstreamMethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";

  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";
}

abstract class ArgumentName {
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
}
