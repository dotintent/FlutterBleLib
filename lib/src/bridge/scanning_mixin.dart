part of _internal;

mixin ScanningMixin on FlutterBLE {
  EventChannel _eventChannel;

  EventChannel get eventChannel =>
      _eventChannel ??= const EventChannel(ChannelName.scanningEvents);

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
    bool allowDuplicates,
  ) {
    return eventChannel
        .receiveBroadcastStream(
          <String, dynamic>{
            ArgumentName.scanMode: scanMode,
            ArgumentName.callbackType: callbackType,
            ArgumentName.uuids: uuids,
            ArgumentName.allowDuplicates: allowDuplicates,
          },
        )
        .handleError(
          (errorJson) => throw BleError.fromJson(jsonDecode(errorJson.details)),
          test: (error) => error is PlatformException,
        )
        .map(
          (scanResultJson) =>
              ScanResult.fromJson(jsonDecode(scanResultJson), _manager),
        );
  }

  Future<void> stopDeviceScan() async {
    await _methodChannel.invokeMethod(MethodName.stopDeviceScan);
  }
}
