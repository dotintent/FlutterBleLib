part of internal;

class ScanResult {
  final String name;
  final String id;

  final int mtu;
  final int rssi;
  final bool isConnectable;
  final int txPowerLevel;

  final Uint8List manufacturerData;
  final Map<String, Uint8List> serviceData;
  final List<String> serviceUuids;

  final String localName;
  final List<String> solicitedServiceUuids;
  final List<String> overflowUuids;

  ScanResult(ScanInfo scanInfo, SimulatedPeripheral peripheral)
      : name = peripheral.name,
        id = peripheral.id,
        mtu = scanInfo.mtu,
        rssi = scanInfo.rssi,
        isConnectable = scanInfo.isConnectable,
        txPowerLevel = scanInfo.txPowerLevel,
        manufacturerData = scanInfo.manufacturerData,
        serviceData = scanInfo.serviceData,
        serviceUuids = scanInfo.serviceUuids,
        localName = scanInfo.localName,
        solicitedServiceUuids = scanInfo.solicitedServiceUuids,
        overflowUuids = scanInfo.overflowUuids;
}