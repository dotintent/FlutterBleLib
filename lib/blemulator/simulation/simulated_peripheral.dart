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
      {this.rssi = defaultRssi,
      this.mtu = defaultMtu,
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
  final StreamController<FlutterBLELib.PeripheralConnectionState>
      _connectionStateStreamController;

  bool _isConnected = false;

  SimulatedPeripheral(
      {@required this.name,
      @required this.id,
      @required this.advertisementInterval,
      @required List<SimulatedService> services,
      this.scanInfo})
      : _connectionStateStreamController = StreamController.broadcast() {
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

  Stream<FlutterBLELib.PeripheralConnectionState> get connectionStateStream {
    return _connectionStateStreamController.stream;
  }

  Stream<ScanResult> onScan({bool allowDuplicates = true}) async* {
    do {
      await Future.delayed(advertisementInterval);
      yield ScanResult(scanInfo, this);
    } while (allowDuplicates);
  }

  Future<bool> onConnectRequest() async {
    _connectionStateStreamController
        .add(FlutterBLELib.PeripheralConnectionState.connecting);
    return true;
  }

  Future<void> onDiscoveryRequest() async {}

  Future<void> onConnect() async {
    _isConnected = true;
    _connectionStateStreamController
        .add(FlutterBLELib.PeripheralConnectionState.connected);
  }

  Future<void> onDisconnect() async {
    _isConnected = false;
    _connectionStateStreamController
        .add(FlutterBLELib.PeripheralConnectionState.disconnected);
  }

  Future<void> onDiscovery() async {}

  bool isConnected() => _isConnected;

  List<SimulatedService> services() {
      return _services.values.toList();
  }

  SimulatedService service(int id) => _services[id];

  SimulatedCharacteristic getCharacteristicForId(int characteristicIdentifier) {
    SimulatedCharacteristic targetCharacteristic;
    servicesLoop:
    for (SimulatedService service in services()) {
      SimulatedCharacteristic characteristic =
          service.characteristic(characteristicIdentifier);
      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break servicesLoop;
      }
    }
    return targetCharacteristic;
  }

  SimulatedCharacteristic getCharacteristicForService(
    String serviceUuid,
    String characteristicUuid,
  ) {
    SimulatedCharacteristic targetCharacteristic;
    servicesLoop:
    for (SimulatedService service in services()) {
      SimulatedCharacteristic characteristic = service
          .characteristics()
          .firstWhere(
              (characteristic) => characteristic.uuid == characteristicUuid,
              orElse: () => null);
      if (characteristic != null) {
        targetCharacteristic = characteristic;
        break servicesLoop;
      }
    }
    return targetCharacteristic;
  }
}
