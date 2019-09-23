part of flutter_ble_lib;

mixin BluetoothStateMixin on FlutterBLE {
  Future<void> enableRadio(String transactionId) async {
    await _methodChannel.invokeMethod(MethodName.enableRadio, <String, dynamic>{
      ArgumentName.transactionId: transactionId,
    });
  }

  Future<void> disableRadio(String transactionId) async {
    await _methodChannel
        .invokeMethod(MethodName.disableRadio, <String, dynamic>{
      ArgumentName.transactionId: transactionId,
    });
  }
}
