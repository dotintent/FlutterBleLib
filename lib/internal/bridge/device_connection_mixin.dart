part of internal_bridge_lib;

mixin DeviceConnectionMixin on FlutterBLE {
  final EventChannel _peripheralConnectionStateEventChannel =
      const EventChannel(ChannelName.connectionStateChangeEvents);

  Future<void> connectToPeripheral(String deviceIdentifier, bool isAutoConnect,
      int requestMtu, bool refreshGatt, Duration timeout) async {
    return await _methodChannel
        .invokeMethod(MethodName.connectToDevice, <String, dynamic>{
      ArgumentName.deviceIdentifier: deviceIdentifier,
      ArgumentName.isAutoConnect: isAutoConnect,
      ArgumentName.requestMtu: requestMtu,
      ArgumentName.refreshGatt: refreshGatt,
      ArgumentName.timeoutMillis: timeout?.inMilliseconds
    });
  }

  Stream<PeripheralConnectionState> observePeripheralConnectionState(
      String identifier, bool emitCurrentValue) async* {
    Stream<PeripheralConnectionState> peripheralConnectionStateStream =
        _peripheralConnectionStateEventChannel
            .receiveBroadcastStream()
            .map((jsonString) =>
                ConnectionStateContainer.fromJson(jsonDecode(jsonString)))
            .where((connectionStateContainer) =>
                connectionStateContainer.peripheralIdentifier == identifier)
            .map((connectionStateContainer) => connectionStateContainer.connectionState)
            .map((connectionStateString) {
      switch (connectionStateString.toLowerCase()) {
        case NativeConnectionState.connected:
          return PeripheralConnectionState.connected;
        case NativeConnectionState.connecting:
          return PeripheralConnectionState.connecting;
        case NativeConnectionState.disconnected:
          return PeripheralConnectionState.disconnected;
        case NativeConnectionState.disconnecting:
          return PeripheralConnectionState.disconnecting;
        default:
          throw FormatException(
              "Unrecognized value of device connection state. Value: $connectionStateString");
      }
    });

    yield* peripheralConnectionStateStream;

    _methodChannel
        .invokeMethod(MethodName.observeConnectionState, <String, dynamic>{
      ArgumentName.deviceIdentifier: identifier,
      ArgumentName.emitCurrentValue: emitCurrentValue,
    });
  }

  Future<bool> isPeripheralConnected(String peripheralIdentifier) async {
    return await _methodChannel
        .invokeMethod(MethodName.isDeviceConnected, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheralIdentifier,
    });
  }

  Future<void> disconnectOrCancelPeripheralConnection(
      String peripheralIdentifier) async {
    return await _methodChannel
        .invokeMethod(MethodName.cancelConnection, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheralIdentifier,
    });
  }
}
