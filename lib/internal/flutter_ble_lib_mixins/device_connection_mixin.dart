part of flutter_ble_lib;

mixin DeviceConnectionMixin on FlutterBLE {
  final EventChannel _peripheralConnectionStateEventChannel =
  const EventChannel(ChannelName.CONNECTION_STATE_CHANGE_EVENTS);

  Future<void> connectToPeripheral(String deviceIdentifier, bool isAutoConnect,
      int requestMtu, bool refreshGatt, Duration timeout) async {
    return await _methodChannel
        .invokeMethod(MethodName.CONNECT_TO_DEVICE, <String, dynamic>{
      ArgumentName.DEVICE_IDENTIFIER: deviceIdentifier,
      ArgumentName.IS_AUTO_CONNECT: isAutoConnect,
      ArgumentName.REQUESTU_MTU: requestMtu,
      ArgumentName.REFRESH_GATT: refreshGatt,
      ArgumentName.TIMEOUT_MILLIS: timeout.inMilliseconds
    });
  }

  Stream<PeripheralConnectionState> observePeripheralConnectionState(
      String identifier, bool emitCurrentValue) async* {
    _methodChannel
        .invokeMethod(MethodName.OBSERVE_CONNECTION_STATE, <String, dynamic>{
      ArgumentName.DEVICE_IDENTIFIER: identifier,
      ArgumentName.EMIT_CURRENT_VALUE: emitCurrentValue
    });

    yield* _peripheralConnectionStateEventChannel
        .receiveBroadcastStream()
        .map((rawValue) {
      switch (rawValue) {
        case NativeConnectionState.CONNECTED:
          return PeripheralConnectionState.connected;
        case NativeConnectionState.CONNECTING:
          return PeripheralConnectionState.connecting;
        case NativeConnectionState.DISCONNECTED:
          return PeripheralConnectionState.disconnected;
        case NativeConnectionState.DISCONNECTING:
          return PeripheralConnectionState.disconnecting;
        default:
          throw FormatException(
              "Unrecognized value of device connection state. Value: $rawValue");
      }
    });
  }

  Future<bool> isPeripheralConnected(String peripheralIdentifier) async {
    return await _methodChannel.invokeMethod(
        MethodName.IS_DEVICE_CONNECTED, <String, dynamic>{
      ArgumentName.DEVICE_IDENTIFIER: peripheralIdentifier
    });
  }

  Future<void> disconnectOrCancelPeripheralConnection(
      String peripheralIdentifier) async {
    return await _methodChannel.invokeMethod(
        MethodName.CANCEL_CONNECTION, <String, dynamic>{
      ArgumentName.DEVICE_IDENTIFIER: peripheralIdentifier
    });
  }
}