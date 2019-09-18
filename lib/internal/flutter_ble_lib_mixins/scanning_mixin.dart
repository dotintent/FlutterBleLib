part of flutter_ble_lib;

mixin ScanningMixin on FlutterBLE {
  final EventChannel _scanEventChannel =
      const EventChannel(ChannelName.scanningEvents);

  StreamController _scanningStreamController;

  Stream<ScanResult> startDeviceScan(
    int scanMode,
    int callbackType,
    List<String> uuids,
  ) async* {
    _scanningStreamController ?? _initScanning(scanMode, callbackType, uuids);

    yield* _scanningStreamController.stream.handleError((errorJson) {
      _deinitScanning();
      throw BleError.fromJson(jsonDecode(errorJson.details));
    }, test: (error) => error is PlatformException).map(
        (scanResultJson) => ScanResult.fromJson(
              jsonDecode(scanResultJson),
              _manager,
            ));
  }

  Future<void> stopDeviceScan() async {
    _deinitScanning();
    await _methodChannel.invokeMethod(MethodName.stopDeviceScan);
    return;
  }

  void _initScanning(
    int scanMode,
    int callbackType,
    List<String> uuids,
  ) {
    StreamSubscription scanningSubscription;

    _methodChannel.invokeMethod(
      MethodName.startDeviceScan,
      <String, dynamic>{
        ArgumentName.scanMode: scanMode,
        ArgumentName.callbackType: callbackType,
        ArgumentName.uuids: uuids
      },
    );
    _scanningStreamController = StreamController(onCancel: () {
      scanningSubscription?.cancel();
      scanningSubscription = null;
    });

    scanningSubscription = _scanEventChannel.receiveBroadcastStream().listen(
          _scanningStreamController.add,
          onError: _scanningStreamController.addError,
        );
  }

  void _deinitScanning() {
    _scanningStreamController?.close();
    _scanningStreamController = null;
  }
}
