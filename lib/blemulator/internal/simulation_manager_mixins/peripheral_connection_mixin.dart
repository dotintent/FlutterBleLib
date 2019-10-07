part of internal;

mixin PeripheralConnectionMixin on SimulationManagerBaseWithErrorChecks {
  Map<String, StreamSubscription> _connectionStateSubscriptions = Map();

  Future<void> _connectToDevice(String identifier) async {
    await _errorIfUnknown(identifier);

    addConnectionStateObserverIfNeeded(identifier);

    await _errorIfConnected(identifier);

    await _errorIfCannotConnect(identifier);
    return _peripherals[identifier].onConnect();
  }

  void addConnectionStateObserverIfNeeded(String identifier) {
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
  }

  Future<bool> _isDeviceConnected(String identifier) async {
    await _errorIfUnknown(identifier);
    return _peripherals[identifier].isConnected();
  }

  Future<void> _disconnectOrCancelConnection(String identifier) async {
    await _errorIfUnknown(identifier);
    await _errorIfNotConnected(identifier);
    return _peripherals[identifier].onDisconnect();
  }
}