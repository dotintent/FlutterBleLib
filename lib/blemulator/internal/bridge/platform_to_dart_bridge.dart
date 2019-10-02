part of internal;

class PlatformToDartBridge {
  SimulationManager _manager;
  MethodChannel _platformToDartChannel;

  PlatformToDartBridge(this._manager) {
    _platformToDartChannel = new MethodChannel(ChannelName.platformToDart);
    _platformToDartChannel.setMethodCallHandler(_handleCall);
  }

  Future<dynamic> _handleCall(MethodCall call) {
    switch (call.method) {
      case DartMethodName.createClient:
        return _createClient(call);
      case DartMethodName.destroyClient:
        return _destroyClient(call);
      case DartMethodName.startDeviceScan:
        return _startDeviceScan(call);
      case DartMethodName.stopDeviceScan:
        return _stopDeviceScan(call);
      case DartMethodName.connectToPeripheral:
        return _connectToDevice(call);
      case DartMethodName.isPeripheralConnected:
        return _isDeviceConnected(call);
      case DartMethodName.disconnectOrCancelConnectionToPeripheral:
        return _disconnectOrCancelConnection(call);
      default:
         return Future.error(UnimplementedError("${call.method} is not implemented"));
    }
  }

  Future<void> _createClient(MethodCall call) async {
    await _manager._createClient();
  }

  Future<void> _destroyClient(MethodCall call) async {
    await _manager._destroyClient();
  }

  Future<void> _startDeviceScan(MethodCall call) async {
    await _manager._startDeviceScan();
  }

  Future<void> _stopDeviceScan(MethodCall call) async {
    await _manager._stopDeviceScan();
  }

  Future<void> _connectToDevice(MethodCall call) async {
    await _manager._connectToDevice(call.arguments[ArgumentName.id] as String);
  }

  Future<bool> _isDeviceConnected(MethodCall call) async {
    return await _manager
        ._isDeviceConnected(call.arguments[ArgumentName.id] as String);
  }

  Future<void> _disconnectOrCancelConnection(MethodCall call) async {
    await _manager._disconnectOrCancelConnection(
        call.arguments[ArgumentName.id] as String);
  }
}
