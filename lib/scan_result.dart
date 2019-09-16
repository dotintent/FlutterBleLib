part of flutter_ble_lib;

abstract class _Metadata {
  static const String id = "id";
  static const String name = "name";
  static const String rssi = "rssi";
  static const String mtu = "mtu";
  static const String manufacturerData = "manufacturerData";
  static const String serviceData = "serviceData";
  static const String serviceUuids = "serviceUUIDs";
  static const String localName = "localName";
  static const String txPowerLevel = "txPowerLevel";
  static const String solicitedServiceUuids = "solicitedServiceUUIDs";
  static const String isConnectable = "isConnectable";
  static const String overflowServiceUuids = "overflowServiceUUIDs";
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
      : deviceId = json[_Metadata.id],
        deviceName = json[_Metadata.name],
        rssi = json[_Metadata.rssi],
        mtu = json[_Metadata.mtu],
        isConnectable = json[_Metadata.isConnectable],
        overflowServiceUUIDs = json[_Metadata.overflowServiceUuids],
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
      : manufacturerData = _decodeBase64OrNull(_Metadata.manufacturerData),
        serviceData = _getServiceDataOrNull(json[_Metadata.serviceData]),
        serviceUUIDs = _mapToListOfStringsOrNull(json[_Metadata.serviceUuids]),
        localName = json[_Metadata.localName],
        txPowerLevel = json[_Metadata.txPowerLevel],
        solicitedServiceUUIDs =
            _mapToListOfStringsOrNull(json[_Metadata.solicitedServiceUuids]);

  static Map<String, Int8List> _getServiceDataOrNull(
      Map<String, dynamic> serviceData) {
    return serviceData?.map(
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
