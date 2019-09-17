abstract class _Metadata {
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
      : errorCode = json[_Metadata.ERROR_CODE],
        attErrorCode = json[_Metadata.ATT_ERROR_CODE],
        androidErrorCode = json[_Metadata.ANDROID_ERROR_CODE],
        reason = json[_Metadata.REASON],
        deviceID = json[_Metadata.DEVICE_ID],
        serviceUUID = json[_Metadata.SERVICE_UUID],
        characteristicUUID = json[_Metadata.CHARACTERISTIC_UUID],
        descriptorUUID = json[_Metadata.DESCRIPTOR_UUID],
        internalMessage = json[_Metadata.INTERNAL_MESSAGE];
}
