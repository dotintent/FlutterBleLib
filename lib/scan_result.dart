part of flutter_ble_lib;

abstract class _ScanResultMetadata {
  static const String id = "id";
  static const String name = "name";
  static const String rssi = "rssi";
  static const String manufacturerData = "manufacturerData";
  static const String serviceData = "serviceData";
  static const String serviceUuids = "serviceUUIDs";
  static const String localName = "localName";
  static const String txPowerLevel = "txPowerLevel";
  static const String solicitedServiceUuids = "solicitedServiceUUIDs";
  static const String isConnectable = "isConnectable";
  static const String overflowServiceUuids = "overflowServiceUUIDs";
}

/// A scan result emitted by the scanning operation, containing [Peripheral] and [AdvertisementData].
class ScanResult {
  Peripheral peripheral;

  /// Signal strength of the device in dBm.
  int rssi;
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
        isConnectable = json[_ScanResultMetadata.isConnectable],
        overflowServiceUUIDs = json[_ScanResultMetadata.overflowServiceUuids],
        advertisementData = AdvertisementData._fromJson(json);
}

/// A container for BLE advertisement data with convenient accessors for
/// common items.
class AdvertisementData {
  /// The manufacturer data of the device.
  Uint8List manufacturerData;

  /// A dictionary that contains service-specific advertisement data.
  Map<String, Uint8List> serviceData;

  /// A list of service UUIDs.
  List<String> serviceUUIDs;

  /// The local name of the device.
  ///
  /// It may be the same as [Peripheral.name] but sometimes one of them or
  /// both are `null`.
  String localName;

  /// The transmit power of the device.
  int txPowerLevel;

  /// A list of solicited service UUIDs.
  List<String> solicitedServiceUUIDs;

  /// Deserializes [AdvertisementData] from JSON.
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
