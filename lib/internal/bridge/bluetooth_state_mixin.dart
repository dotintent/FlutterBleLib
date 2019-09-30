part of internal_bridge_lib;

mixin BluetoothStateMixin on FlutterBLE {
  final EventChannel _adapterStateChanges =
      const EventChannel(ChannelName.adapterStateChanges);

  Future<void> enableRadio(String transactionId) async {
    await _methodChannel.invokeMethod(
      MethodName.enableRadio,
      <String, dynamic>{
        ArgumentName.transactionId: transactionId,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));
  }

  Future<void> disableRadio(String transactionId) async {
    await _methodChannel.invokeMethod(
      MethodName.disableRadio,
      <String, dynamic>{
        ArgumentName.transactionId: transactionId,
      },
    ).catchError((errorJson) =>
        Future.error(BleError.fromJson(jsonDecode(errorJson.details))));
  }

  Future<BluetoothState> state() => _methodChannel
      .invokeMethod(MethodName.getState)
      .then(_mapToBluetoothState);

  Stream<BluetoothState> onStateChange(bool emitCurrentValue) async* {
    if (emitCurrentValue == true) {
      BluetoothState currentState = await state();
      yield currentState;
    }
    yield* _adapterStateChanges
        .receiveBroadcastStream()
        .map(_mapToBluetoothState);
  }

  BluetoothState _mapToBluetoothState(dynamic rawValue) {
    switch (rawValue) {
      case "Unknown":
        return BluetoothState.UNKNOWN;
      case "Unsupported":
        return BluetoothState.UNSUPPORTED;
      case "Unauthorized":
        return BluetoothState.UNAUTHORIZED;
      case "Resetting":
        return BluetoothState.RESETTING;
      case "PoweredOn":
        return BluetoothState.POWERED_ON;
      case "PoweredOff":
        return BluetoothState.POWERED_OFF;
      default:
        throw "Cannot map $rawValue to known bluetooth state";
    }
  }
}
