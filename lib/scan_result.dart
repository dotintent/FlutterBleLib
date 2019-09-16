part of flutter_ble_lib;

abstract class Metadata {
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
      : deviceId = json[Metadata.ID],
        deviceName = json[Metadata.NAME],
        rssi = json[Metadata.RSSI],
        mtu = json[Metadata.MTU],
        isConnectable = json[Metadata.IS_CONNECTABLE],
        overflowServiceUUIDs = json[Metadata.OVERFLOW_SERVICE_UUIDS],
        advertisementData = AdvertisementData.fromJson(json);
}

class AdvertisementData {
  Uint8List manufacturerData;
  Map<String, Uint8List> serviceData;
  List<String> serviceUUIDs;
  String localName;
  int txPowerLevel;
  List<String> solicitedServiceUUIDs;

  AdvertisementData._fromJson(Map<String, dynamic> json)
      : manufacturerData = _base64ToUint8ListOrNull(Metadata.MANUFACTURER_DATA),
        serviceData = _getServiceDataOrNull(json),
        serviceUUIDs = _mapToStringsListOrNull(json[Metadata.SERVICE_UUIDS]),
        localName = json[Metadata.LOCAL_NAME],
        txPowerLevel = json[Metadata.TX_POWER_LEVEL],
        solicitedServiceUUIDs = _mapToStringsListOrNull(json[Metadata.SOLICITED_SERVICE_UUIDS]);

  static Map<String, Uint8List> _getServiceDataOrNull(
      Map<String, dynamic> json) {
    Map<String, dynamic> rawServiceData = json[Metadata.SERVICE_DATA];
    return rawServiceData?.map((key, value) {
      return MapEntry(key, base64Decode(value));
    });
  }

  static Uint8List _base64ToUint8ListOrNull(String base64Value) {
    if (base64Value != null)
      return base64.decode(base64Value);
    else
      return null;
  }

  static List<String> _mapToStringsListOrNull(List<dynamic> values) {
    return values?.cast();
  }
}
