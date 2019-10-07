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
  int errorCode;
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
      : errorCode = json[_BleErrorMetadata.ERROR_CODE],
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
      "Error code: $errorCode, "
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
