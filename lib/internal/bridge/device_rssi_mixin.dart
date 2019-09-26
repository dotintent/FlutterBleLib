part of internal_bridge_lib;

mixin RssiMixin on FlutterBLE {

  Future<int> rssi(Peripheral peripheral, String transactionId) async {
    return await _methodChannel.invokeMethod(MethodName.rssi, <String, dynamic>{
      ArgumentName.deviceIdentifier: peripheral.identifier,
      ArgumentName.transactionId: transactionId
    });
  }
}