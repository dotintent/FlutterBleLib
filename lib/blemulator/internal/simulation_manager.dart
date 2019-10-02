part of internal;

class SimulationManager {
  Map<String, SimulatedPeripheral> _peripherals = Map();
  List<StreamSubscription> _scanSubscriptions = [];
  Map<String, StreamSubscription> _connectionStateSubscriptions = Map();
  DartToPlatformBridge _bridge;

  SimulationManager(this._bridge);

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    SimulatedPeripheral mapEntry =
        _peripherals.putIfAbsent(peripheral.id, () => peripheral);

    if (!identical(mapEntry, peripheral)) {
      print("Peripheral not added - there already"
          " exists a peripheral with the same id!");
    }
  }

  void removeAllSimulatedPeripherals() {
    _peripherals.clear();
    //TODO notify bridge?
  }

  Future<void> _createClient() async {
    print("entered create client");
  }

  Future<void> _destroyClient() async {}

  Future<void> _startDeviceScan() async {
    _peripherals.values.forEach((peripheral) {
      _scanSubscriptions
          .add(peripheral.onScan(allowDuplicates: true).listen((scanResult) {
        print(scanResult);
        return _bridge.publishScanResult(scanResult);
      }));
    });
  }

  Future<void> _stopDeviceScan() async {
    _scanSubscriptions.forEach((subscription) => subscription.cancel());
    _scanSubscriptions.clear();
  }

  Future<void> _connectToDevice(String identifier) async {
    if (_peripherals[identifier] != null) {
      _connectionStateSubscriptions.putIfAbsent(
          identifier,
              () => _peripherals[identifier]
              .connectionStateStream
              .listen((connectionState) {
            _bridge.publishConnectionState(
                _peripherals[identifier], connectionState);

            if (connectionState == PeripheralConnectionState.disconnected) {
              _connectionStateSubscriptions[identifier].cancel();
              _connectionStateSubscriptions.remove(identifier);
            }
          }));

      bool canConnect = await _peripherals[identifier].onConnectRequest();

      if (canConnect) {
        _peripherals[identifier].onConnect();
      }
    } else {
      return Future.error("Unknown device identifier $identifier");
    }
  }

  Future<bool> _isDeviceConnected(String identifier) async {
    if (_peripherals[identifier] != null) {
      return _peripherals[identifier].isConnected();
    } else {
      return Future.error("Unknown device identifier $identifier");
    }
  }

  Future<void> _disconnectOrCancelConnection(String identifier) async {
    if (_peripherals[identifier] != null) {
      return _peripherals[identifier].onDisconnect();
    } else {
      return Future.error("Unknown device identifier $identifier");
    }
  }
}
