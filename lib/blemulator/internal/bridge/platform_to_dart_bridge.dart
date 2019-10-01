part of internal;

class PlatformToDartBridge {

  SimulationManager _manager;
  MethodChannel _upstreamChannel;

  PlatformToDartBridge(this._manager) {
    _upstreamChannel = new MethodChannel(ChannelName.upstream);
    _upstreamChannel.setMethodCallHandler(_handleCall);
  }

  Future<dynamic> _handleCall(MethodCall call) {
    switch (call.method) {
      case DartMethodName.createClient:
        return _createClient();
      case DartMethodName.destroyClient:
        return _destroyClient();
      case DartMethodName.startDeviceScan:
        return _startDeviceScan();
      case DartMethodName.stopDeviceScan:
        return _stopDeviceScan();
      default:
        throw UnimplementedError("${call.method} is not implemented");
    }
  }

  Future<void> _createClient() async {
    await _manager._createClient();
  }

  Future<void> _destroyClient() async {
    await _manager._destroyClient();
  }

  Future<void> _startDeviceScan() async {
    await _manager._startDeviceScan();
  }

  Future<void> _stopDeviceScan() async {
    await _manager._stopDeviceScan();
  }
}
