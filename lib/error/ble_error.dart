part of flutter_ble_lib;

abstract class _BleErrorMetadata {
  static const String ERROR_CODE = "errorCode";
  static const String ATT_ERROR_CODE = "attErrorCode";
  static const String ANDROID_ERROR_CODE = "androidErrorCode";
  static const String REASON = "reason";
  static const String DEVICE_ID = "deviceID";
  static const String SERVICE_UUID = "serviceUUID";
  static const String CHARACTERISTIC_UUID = "characteristicUUID";
  static const String DESCRIPTOR_UUID = "descriptorUUID";
  static const String INTERNAL_MESSAGE = "internalMessage";
}

class BleError {
  BleErrorCode errorCode;
  int attErrorCode;
  int iosErrorCode;
  int androidErrorCode;
  String reason;

  String deviceID;
  String serviceUUID;
  String characteristicUUID;
  String descriptorUUID;
  String internalMessage;

  BleError.fromJson(Map<String, dynamic> json)
      : errorCode = BleErrorCode(json[_BleErrorMetadata.ERROR_CODE]),
        attErrorCode = json[_BleErrorMetadata.ATT_ERROR_CODE],
        androidErrorCode = json[_BleErrorMetadata.ANDROID_ERROR_CODE],
        reason = json[_BleErrorMetadata.REASON],
        deviceID = json[_BleErrorMetadata.DEVICE_ID],
        serviceUUID = json[_BleErrorMetadata.SERVICE_UUID],
        characteristicUUID = json[_BleErrorMetadata.CHARACTERISTIC_UUID],
        descriptorUUID = json[_BleErrorMetadata.DESCRIPTOR_UUID],
        internalMessage = json[_BleErrorMetadata.INTERNAL_MESSAGE];

  @override
  String toString() => "BleError ("
      "Error code: ${errorCode.value}, "
      "ATT error code: $attErrorCode, "
      "iOS error code: $iosErrorCode, "
      "Android error code: $androidErrorCode, "
      "reason: $reason, "
      "internal message: $internalMessage, "
      "device ID: $deviceID, "
      "service UUID: $serviceUUID, "
      "characteristic UUID: $characteristicUUID, "
      "descriptor UUID: $descriptorUUID)";
}

class BleErrorCode {
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

  int value;

  BleErrorCode(this.value);
}