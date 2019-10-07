part of internal;

//TODO Move to separated mixin along with all operations on characteristics

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
      case DartMethodName.readCharacteristicForDevice:
        return _readCharacteristicForDevice(call);
      case DartMethodName.readCharacteristicForService:
        return _readCharacteristicForService(call);
      case DartMethodName.readCharacteristicForIdentifier:
        return _readCharacteristicForIdentifier(call);
      default:
         return Future.error(UnimplementedError("${call.method} is not implemented"));
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

  Future<dynamic> _readCharacteristicForIdentifier(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForIdentifier(
            arguments[SimulationArgumentName.characteristicId])
        .then((characteristic) => _convertToMap(
            arguments[SimulationArgumentName.deviceIdentifier], characteristic));
  }

  Future<dynamic> _readCharacteristicForDevice(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForDevice(
          arguments[SimulationArgumentName.deviceIdentifier],
          arguments[SimulationArgumentName.serviceUuid],
          arguments[SimulationArgumentName.characteristicUuid],
        )
        .then((characteristic) => _convertToMap(
            arguments[SimulationArgumentName.deviceIdentifier], characteristic));
  }

  Future<dynamic> _readCharacteristicForService(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForService(
          arguments[SimulationArgumentName.serviceId],
          arguments[SimulationArgumentName.characteristicUuid],
        )
        .then((characteristic) => _convertToMap(
            arguments[SimulationArgumentName.deviceIdentifier], characteristic));
  }

  Map<String, dynamic> _convertToMap(String peripheralId, SimulatedCharacteristic characteristic) =>
      <String, dynamic>{
        Metadata.deviceIdentifier: peripheralId,
        Metadata.characteristicUuid: characteristic.uuid,
        Metadata.value: characteristic.value,
        Metadata.serviceUuid: characteristic.service.uuid,
        Metadata.serviceId: characteristic.service.id,
        Metadata.isReadable: characteristic.isReadable,
        Metadata.isWritableWithResponse:
            characteristic.isWritableWithResponse,
        Metadata.isWritableWithoutResponse:
            characteristic.isWritableWithoutResponse,
        Metadata.isNotifiable: characteristic.isNotifiable,
        Metadata.isNotifying: characteristic.isNotifying,
        Metadata.isIndicatable: characteristic.isIndicatable,
      };
}
