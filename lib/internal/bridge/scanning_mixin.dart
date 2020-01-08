part of internal_bridge_lib;

mixin ScanningMixin on FlutterBLE {
  Stream<dynamic> _scanEvents;

  void _prepareScanEventsStream() {
    _scanEvents =
        const EventChannel(ChannelName.scanningEvents).receiveBroadcastStream();
  }

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
    bool allowDuplicates,
  ) async* {
    if (_scanEvents == null) {
      _prepareScanEventsStream();
    }

    _methodChannel.invokeMethod(
      MethodName.startDeviceScan,
      <String, dynamic>{
        ArgumentName.scanMode: scanMode,
        ArgumentName.callbackType: callbackType,
        ArgumentName.uuids: uuids,
        ArgumentName.allowDuplicates: allowDuplicates,
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
    _scanEvents = null;
    return;
  }
}
