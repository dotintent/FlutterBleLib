part of flutter_ble_lib;

abstract class _ScanResultMetadata {
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

/// An item returned by [BleManager] during scanning.
class ScanResult {
  Peripheral peripheral;

  /// Signal strength of the device in dBm.
  int rssi;

  /// The size of the data unit within an ATT packet.
  int mtu;

  /// An indicator whether the device is connectable (iOS only).
  bool isConnectable;

  /// A list of UUIDs found in the overflow area of the advertisement data (iOS only).
  List<String> overflowServiceUUIDs;

  /// A packet of data advertised by the device.
  AdvertisementData advertisementData;

  /// Deserializes [ScanResult] from JSON.
  ScanResult.fromJson(Map<String, dynamic> json, ManagerForPeripheral manager)
      : peripheral = Peripheral.fromJson(json, manager),
        rssi = json[_ScanResultMetadata.rssi],
        mtu = json[_ScanResultMetadata.mtu],
        isConnectable = json[_ScanResultMetadata.isConnectable],
        overflowServiceUUIDs = json[_ScanResultMetadata.overflowServiceUuids],
        advertisementData = AdvertisementData._fromJson(json);
}

class AdvertisementData {
  Uint8List manufacturerData;
  Map<String, Uint8List> serviceData;
  List<String> serviceUUIDs;
  String localName;
  int txPowerLevel;
  List<String> solicitedServiceUUIDs;

  AdvertisementData._fromJson(Map<String, dynamic> json)
      : manufacturerData =
            _decodeBase64OrNull(json[_ScanResultMetadata.manufacturerData]),
        serviceData =
            _getServiceDataOrNull(json[_ScanResultMetadata.serviceData]),
        serviceUUIDs =
            _mapToListOfStringsOrNull(json[_ScanResultMetadata.serviceUuids]),
        localName = json[_ScanResultMetadata.localName],
        txPowerLevel = json[_ScanResultMetadata.txPowerLevel],
        solicitedServiceUUIDs = _mapToListOfStringsOrNull(
            json[_ScanResultMetadata.solicitedServiceUuids]);

  static Map<String, Uint8List> _getServiceDataOrNull(
      Map<String, dynamic> serviceData) {
    return serviceData?.map(
      (key, value) => MapEntry(key, base64Decode(value)),
    );
  }

  static Uint8List _decodeBase64OrNull(String base64Value) {
    if (base64Value != null)
      return base64.decode(base64Value);
    else
      return null;
  }

  static List<String> _mapToListOfStringsOrNull(List<dynamic> values) =>
      values?.cast();
}
