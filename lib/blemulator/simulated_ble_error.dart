part of blemulator;

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

class SimulatedBleError extends Error {
  static final String _errorCode = "errorCode";
  static final String _reason = "reason";
  int errorCode;
  String reason;

  SimulatedBleError(this.errorCode, this.reason);

  @override
  String toString() {
    return jsonEncode(<String, dynamic>{
      _errorCode: errorCode,
      _reason: reason,
    });
  }
}
