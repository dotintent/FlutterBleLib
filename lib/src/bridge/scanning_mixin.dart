part of _internal;

mixin ScanningMixin on FlutterBLE {
  Stream<ScanResult>? __scanEvents;
  Stream<ScanResult> get _scanEvents {
    var scanEvents = __scanEvents;
    if (scanEvents == null) {
      scanEvents = 
        const EventChannel(
          ChannelName.scanningEvents
        ).receiveBroadcastStream(
        ).handleError(
          (errorJson) => throw BleError.fromJson(
            jsonDecode(errorJson.details)
          ),
          test: (error) => error is PlatformException,
        ).map(
          (scanResultJson) =>
              ScanResult.fromJson(jsonDecode(scanResultJson), _manager),
        );
      __scanEvents = scanEvents;
    }
    return scanEvents;
  }
  void _resetScanEvents() {
    __scanEvents = null;
  }

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
    bool allowDuplicates,
  ) {
    final streamController = StreamController<ScanResult>.broadcast(
      onListen: () => _methodChannel.invokeMethod(
        MethodName.startDeviceScan,
        <String, dynamic>{
          ArgumentName.scanMode: scanMode,
          ArgumentName.callbackType: callbackType,
          ArgumentName.uuids: uuids,
          ArgumentName.allowDuplicates: allowDuplicates,
        },
      ),
      onCancel: () => stopDeviceScan(),
    );

    streamController
        .addStream(_scanEvents, cancelOnError: true)
        .then((_) => streamController.close());

    return streamController.stream;
  }

  Future<void> stopDeviceScan() async {
    await _methodChannel.invokeMethod(MethodName.stopDeviceScan);
    _resetScanEvents();
    return;
  }
}
