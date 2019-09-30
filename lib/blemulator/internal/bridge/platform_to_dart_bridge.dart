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
