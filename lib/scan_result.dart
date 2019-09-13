part of flutter_ble_lib;

abstract class _Metadata {
  static const String ID = "id";
  static const String NAME = "name";
  static const String RSSI = "rssi";
  static const String MTU = "mtu";
  static const String MANUFACTURER_DATA = "manufacturerData";
  static const String SERVICE_DATA = "serviceData";
  static const String SERVICE_UUIDS = "serviceUUIDs";
  static const String LOCAL_NAME = "localName";
  static const String TX_POWER_LEVEL = "txPowerLevel";
  static const String SOLICITED_SERVICE_UUIDS = "solicitedServiceUUIDs";
  static const String IS_CONNECTABLE = "isConnectable";
  static const String OVERFLOW_SERVICE_UUIDS = "overflowServiceUUIDs";
}

class ScanResult {
  String deviceId;
  String deviceName;
  int rssi;
  int mtu;
  bool isConnectable;
  List<String> overflowServiceUUIDs;
  AdvertisementData advertisementData;

  ScanResult.fromJson(Map<String, dynamic> json)
      : deviceId = json[_Metadata.ID],
        deviceName = json[_Metadata.NAME],
        rssi = json[_Metadata.RSSI],
        mtu = json[_Metadata.MTU],
        isConnectable = json[_Metadata.IS_CONNECTABLE],
        overflowServiceUUIDs = json[_Metadata.OVERFLOW_SERVICE_UUIDS],
        advertisementData = AdvertisementData._fromJson(json);
}

class AdvertisementData {
  Int8List manufacturerData;
  Map<String, Int8List> serviceData;
  List<String> serviceUUIDs;
  String localName;
  int txPowerLevel;
  List<String> solicitedServiceUUIDs;

  AdvertisementData._fromJson(Map<String, dynamic> json)
      : manufacturerData = _decodeBase64OrNull(_Metadata.MANUFACTURER_DATA),
        serviceData = _getServiceDataOrNull(json),
        serviceUUIDs = _mapToListOfStringsOrNull(json[_Metadata.SERVICE_UUIDS]),
        localName = json[_Metadata.LOCAL_NAME],
        txPowerLevel = json[_Metadata.TX_POWER_LEVEL],
        solicitedServiceUUIDs =
            _mapToListOfStringsOrNull(json[_Metadata.SOLICITED_SERVICE_UUIDS]);

  static Map<String, Int8List> _getServiceDataOrNull(
      Map<String, dynamic> json) {
    return json[_Metadata.SERVICE_DATA]?.map(
      (key, value) => MapEntry(key, Int8List.fromList(base64Decode(value))),
    );
  }

  static Int8List _decodeBase64OrNull(String base64Value) {
    if (base64Value != null)
      return Int8List.fromList(base64.decode(base64Value));
    else
      return null;
  }

  static List<String> _mapToListOfStringsOrNull(List<dynamic> values) =>
      values?.cast();
}
