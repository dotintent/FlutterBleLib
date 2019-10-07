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
      case DartMethodName.discoverAllServicesAndCharacteristics:
        return _discoverAllServicesAndCharacteristics(call);
      default:
        return Future.error(
          SimulatedBleError(
            BleErrorCode.UnknownError,
            "${call.method} is not implemented",
          ),
        );
    }
  }

  Future<void> _createClient(MethodCall call) {
    return _manager._createClient();
  }

  Future<void> _destroyClient(MethodCall call) {
    return _manager._destroyClient();
  }

  Future<void> _startDeviceScan(MethodCall call) {
    return _manager._startDeviceScan();
  }

  Future<void> _stopDeviceScan(MethodCall call) {
    return _manager._stopDeviceScan();
  }

  Future<void> _connectToDevice(MethodCall call) {
    return _manager._connectToDevice(call.arguments[ArgumentName.id] as String);
  }

  Future<bool> _isDeviceConnected(MethodCall call) {
    return _manager
        ._isDeviceConnected(call.arguments[ArgumentName.id] as String);
  }

  Future<void> _disconnectOrCancelConnection(MethodCall call) {
    return _manager._disconnectOrCancelConnection(
        call.arguments[ArgumentName.id] as String);
  }

  Future<List<dynamic>> _discoverAllServicesAndCharacteristics(MethodCall call) async {
    List<SimulatedService> services =
        await _manager.discoverAllServicesAndCharacteristics(call.arguments[ArgumentName.id] as String);
    dynamic mapped =  services.map(
      (e) => <String, dynamic>{
        SimulationArgumentName.uuid: e.uuid,
        SimulationArgumentName.id: e.id,
        SimulationArgumentName.characteristics: e.characteristics().map(
              (e) => <String, dynamic>{
                SimulationArgumentName.id: e.id,
                SimulationArgumentName.uuid: e.uuid,
                //TODO expand model to send all fields
              },
            ).toList(),
      },
    ).toList();

    return mapped;
  }
}
