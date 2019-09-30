part of blemulator;

class ScanInfo {
  int rssi;
  int mtu;
  bool isConnectable;
  int txPowerLevel;

  Uint8List manufacturerData;
  Map<String, Uint8List> serviceData;
  List<String> serviceUuids;

  String localName;
  List<String> solicitedServiceUuids;
  List<String> overflowUuids;

  ScanInfo(
      {this.rssi = -30,
      this.mtu = 23,
      this.isConnectable = true,
      this.txPowerLevel,
      this.manufacturerData,
      this.serviceData,
      this.serviceUuids,
      this.localName,
      this.solicitedServiceUuids,
      this.overflowUuids});
}

abstract class SimulatedPeripheral {
  final String name;
  final String id;
  Duration advertisementInterval;
  ScanInfo scanInfo;

  Map<int, SimulatedService> _services;

  bool _isConnected = false;
  bool _discoveryDone = false;

  SimulatedPeripheral(this.name, this.id, this.advertisementInterval,
      List<SimulatedService> services,
      {this.scanInfo}) {
    if (scanInfo == null) {
      this.scanInfo = ScanInfo();
    }

    if (scanInfo.serviceUuids == null) {
      scanInfo.serviceUuids = [];
    }

    scanInfo.serviceUuids.addAll(services
        .where((service) => service.isAdvertised)
        .map((service) => service.uuid));

    _services = Map.fromIterable(services, key: (service) => service.id);
  }

  Stream<ScanResult> onScan({bool allowDuplicates = true}) async* {
    do {
      await Future.delayed(advertisementInterval);
      yield ScanResult(scanInfo, this);
    } while (allowDuplicates);
  }

  Future<bool> onConnectRequest();

  Future<void> onDiscoveryRequest();

  void onConnect() {
    _isConnected = true;
  }

  void onDisconnect() {
    _isConnected = false;
  }

  Future<void> onDiscovery() async {
    _discoveryDone = true;
  }

  bool isConnected() => _isConnected;

  List<SimulatedService> services() {
    if (!_discoveryDone) {
      return _services.values.toList();
    } else {
      throw Exception(); //TODO
    }
  }

  SimulatedService service(int id) => _services[id];
}
