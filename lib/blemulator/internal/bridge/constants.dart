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
  static const String publishCharacteristicUpdate = "publishCharacteristicUpdate";
  static const String publishCharacteristicMonitoringError = "publishCharacteristicMonitoringError";
}

abstract class DartMethodName {
  static const String createClient = "createClient";
  static const String destroyClient = "destroyClient";

  static const String startDeviceScan = "startDeviceScan";
  static const String stopDeviceScan = "stopDeviceScan";

  static const String connectToPeripheral = "connectToDevice";
  static const String isPeripheralConnected = "isDeviceConnected";
  static const String disconnectOrCancelConnectionToPeripheral =
      "disconnectOrCancelConnection";

  static const String discoverAllServicesAndCharacteristics =
      "discoverAllServicesAndCharacteristics";

  static const String readCharacteristicForIdentifier =
      "readCharacteristicForIdentifier";
  static const String readCharacteristicForDevice =
      "readCharacteristicForDevice";
  static const String readCharacteristicForService =
      "readCharacteristicForService";
  static const String writeCharacteristicForIdentifier =
      "writeCharacteristicForIdentifier";
  static const String writeCharacteristicForDevice =
      "writeCharacteristicForDevice";
  static const String writeCharacteristicForService =
      "writeCharacteristicForService";
  static const String monitorCharacteristicForIdentifier =
      "monitorCharacteristicForIdentifier";
  static const String monitorCharacteristicForDevice =
      "monitorCharacteristicForDevice";
  static const String monitorCharacteristicForService =
      "monitorCharacteristicForService";
  static const String cancelTransaction =
      "cancelTransaction";
  static const String readRssi = "rssi";
}

abstract class SimulationArgumentName {
  static const String deviceIdentifier = "deviceIdentifier";
  static const String serviceUuid = "serviceUuid";
  static const String serviceId = "serviceId";
  static const String characteristicUuid = "characteristicUuid";
  static const String characteristicIdentifier = "characteristicIdentifier";
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
  static const String value = "value";

  static const String connectionState = "connectionState";

  static const String characteristics = "characteristics";
  static const String uuid = "uuid";
  static const String transactionId = "transactionId";
}

abstract class Metadata {
  static const String deviceIdentifier = "deviceIdentifier";

  static const String serviceId = "serviceId";
  static const String serviceUuid = "serviceUuid";
  static const String characteristicUuid = "characteristicUuid";
  static const String characteristicId = "characteristicId";
  static const String isReadable = "isReadable";
  static const String isWritableWithResponse = "isWritableWithResponse";
  static const String isWritableWithoutResponse = "isWritableWithoutResponse";
  static const String isNotifiable = "isNotifiable";
  static const String isNotifying = "isNotifying";
  static const String isIndicatable = "isIndicatable";
  static const String value = "value";

  static const String errorCode = "errorCode";
  static const String reason = "reason";

}

abstract class ArgumentName {
  static const String id = "id";
  static const String serviceUuid = "serviceUuid";
}

abstract class BleErrorCode {
  static const int UnknownError = 0;
  static const int BluetoothManagerDestroyed = 1;
  static const int OperationCancelled = 2;
  static const int OperationTimedOut = 3;
  static const int OperationStartFailed = 4;
  static const int InvalidIdentifiers = 5;

  static const int BluetoothUnsupported = 100;
  static const int BluetoothUnauthorized = 101;
  static const int BluetoothPoweredOff = 102;
  static const int BluetoothInUnknownState = 103;
  static const int BluetoothResetting = 104;
  static const int BluetoothStateChangeFailed = 105;

  static const int DeviceConnectionFailed = 200;
  static const int DeviceDisconnected = 201;
  static const int DeviceRSSIReadFailed = 202;
  static const int DeviceAlreadyConnected = 203;
  static const int DeviceNotFound = 204;
  static const int DeviceNotConnected = 205;
  static const int DeviceMTUChangeFailed = 206;

  static const int ServicesDiscoveryFailed = 300;
  static const int IncludedServicesDiscoveryFailed = 301;
  static const int ServiceNotFound = 302;
  static const int ServicesNotDiscovered = 303;

  static const int CharacteristicsDiscoveryFailed = 400;
  static const int CharacteristicWriteFailed = 401;
  static const int CharacteristicReadFailed = 402;
  static const int CharacteristicNotifyChangeFailed = 403;
  static const int CharacteristicNotFound = 404;
  static const int CharacteristicsNotDiscovered = 405;
  static const int CharacteristicInvalidDataFormat = 406;

  static const int DescriptorsDiscoveryFailed = 500;
  static const int DescriptorWriteFailed = 501;
  static const int DescriptorReadFailed = 502;
  static const int DescriptorNotFound = 503;
  static const int DescriptorsNotDiscovered = 504;
  static const int DescriptorInvalidDataFormat = 505;

  static const int ScanStartFailed = 600;
  static const int LocationServicesDisabled = 601;
}

abstract class NativeConnectionState {
  static const String connecting = "CONNECTING";
  static const String connected = "CONNECTED";
  static const String disconnecting = "DISCONNECTING";
  static const String disconnected = "DISCONNECTED";
}
