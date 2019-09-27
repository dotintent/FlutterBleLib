part of internal;

class SimulatorCallHandler {

  SimulationManager _manager;

  SimulatorCallHandler(this._manager);

  Future<dynamic> handleCall(MethodCall call) {
    switch (call.method) {
      case UpstreamMethodName.createClient:
        return _createClient();
      case UpstreamMethodName.destroyClient:
        return _destroyClient();
      case UpstreamMethodName.startDeviceScan:
        return _startDeviceScan();
      case UpstreamMethodName.stopDeviceScan:
        return _stopDeviceScan();
      default:
        throw UnimplementedError("${call.method} is not implemented");
    }
  }

  Future<void> _createClient() async {
    _manager._createClient();
  }

  Future<void> _destroyClient() async {
    _manager._destroyClient();
  }

  Future<void> _startDeviceScan() async {
    _manager._startDeviceScan();
  }

  Future<void> _stopDeviceScan() async {
    _manager._stopDeviceScan();
  }
}
