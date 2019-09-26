part of internal_bridge_lib;

mixin BluetoothStateMixin on FlutterBLE {
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
}
