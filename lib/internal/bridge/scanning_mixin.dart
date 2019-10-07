part of internal_bridge_lib;

mixin ScanningMixin on FlutterBLE {
  final Stream<dynamic> _scanEvents =
      const EventChannel(ChannelName.scanningEvents).receiveBroadcastStream();

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
  ) async* {
    _methodChannel.invokeMethod(
      MethodName.startDeviceScan,
      <String, dynamic>{
        ArgumentName.scanMode: scanMode,
        ArgumentName.callbackType: callbackType,
        ArgumentName.uuids: uuids
      },
    );
    yield* _scanEvents.handleError(
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
