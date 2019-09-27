part of blemulator;

class ScanInfo {
  int mtu;
  int rssi;
  bool isConnectable;
}

abstract class SimulatedPeripheral {
  String name;
  String id;
  Map<int, SimulatedService> _services;

  bool _isConnected = false;
  bool _discoveryDone = false;

  SimulatedPeripheral(this.name, this.id);

  Stream<ScanResult> onScan();

  Future<bool> onConnectRequest();

  Future<void> onDiscoveryRequest();

  void onConnect() {
    _isConnected = true;
  }

  void onDisconnect() {
    _isConnected = false;
  }

  void onDiscovery() {
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