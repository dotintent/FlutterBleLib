part of flutter_ble_lib;

mixin ScanningMixin on FlutterBLE {
  final EventChannel _scanEventChannel =
      const EventChannel(ChannelName.scanningEvents);

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
  ) async* {
    yield* _scanEventChannel.receiveBroadcastStream().handleError(
      (errorJson) {
        throw BleError.fromJson(jsonDecode(errorJson.details));
      },
      test: (error) => error is PlatformException,
    ).map((scanResultJson) => ScanResult.fromJson(
          jsonDecode(scanResultJson),
          _manager,
        ));
  }

  Future<void> stopDeviceScan() async {
    await _methodChannel.invokeMethod(MethodName.stopDeviceScan);
    return;
  }
}
