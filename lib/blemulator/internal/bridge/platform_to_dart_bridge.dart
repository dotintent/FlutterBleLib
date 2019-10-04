part of internal;

//TODO Move to separated mixin along with all operations on characteristics
abstract class _CharacteristicMetadata {
  static const String uuid = "characteristicUuid";
  static const String id = "id";
  static const String isReadable = "isReadable";
  static const String isWritableWithResponse = "isWritableWithResponse";
  static const String isWritableWithoutResponse = "isWritableWithoutResponse";
  static const String isNotifiable = "isNotifiable";
  static const String isIndicatable = "isIndicatable";
  static const String value = "value";
}

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
      case DartMethodName.readCharacteristicForDevice:
        return _readCharacteristicForDevice(call);
      case DartMethodName.readCharacteristicForService:
        return _readCharacteristicForService(call);
      case DartMethodName.readCharacteristicForIdentifier:
        return _readCharacteristicForIdentifier(call);
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

  Future<dynamic> _readCharacteristicForIdentifier(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForIdentifier(
            arguments[ArgumentName.characteristicId])
        .then((characteristic) => _convertToMap(
            arguments[ArgumentName.deviceIdentifier], characteristic));
  }

  Future<dynamic> _readCharacteristicForDevice(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForDevice(
          arguments[ArgumentName.deviceIdentifier],
          arguments[ArgumentName.serviceUuid],
          arguments[ArgumentName.characteristicUuid],
        )
        .then((characteristic) => _convertToMap(
            arguments[ArgumentName.deviceIdentifier], characteristic));
  }

  Future<dynamic> _readCharacteristicForService(MethodCall call) async {
    Map<dynamic, dynamic> arguments = call.arguments;
    return _manager
        ._readCharacteristicForService(
          arguments[ArgumentName.serviceId],
          arguments[ArgumentName.characteristicUuid],
        )
        .then((characteristic) => _convertToMap(
            arguments[ArgumentName.deviceIdentifier], characteristic));
  }

  Map<String, dynamic> _convertToMap(String peripheralId, characteristic) =>
      <String, dynamic>{
        ArgumentName.deviceIdentifier: peripheralId,
        ArgumentName.characteristicUuid: characteristic.uuid,
        //TODO Change to SimulationArgumentName after merge with peripheral connection feature
        ArgumentName.bytes: characteristic.value,
        //TODO Change to SimulationArgumentName after merge with peripheral connection feature
        ArgumentName.serviceUuid: characteristic.service.uuid,
        //TODO Change to SimulationArgumentName after merge with peripheral connection feature
        ArgumentName.serviceId: characteristic.service.id,
        //TODO Change to SimulationArgumentName after merge with peripheral connection feature
        _CharacteristicMetadata.isReadable: characteristic.isReadable,
        _CharacteristicMetadata.isWritableWithResponse:
            characteristic.isWritableWithResponse,
        _CharacteristicMetadata.isWritableWithoutResponse:
            characteristic.isWritableWithoutResponse,
        _CharacteristicMetadata.isNotifiable: characteristic.isNotifiable,
        _CharacteristicMetadata.isIndicatable: characteristic.isIndicatable,
      };
}
