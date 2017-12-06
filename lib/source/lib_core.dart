part of flutter_ble_lib;

class FlutterBleLib {

  static FlutterBleLib _newInstance = new FlutterBleLib._();

  static FlutterBleLib get instance => _newInstance;

  static const MethodChannel _mainMethodChannel =
  const MethodChannel('flutter_ble_lib');

  static const EventChannel _scanDevicesChanel =
  const EventChannel('flutter_ble_lib/scanDevices');

  final StreamController<MethodCall> _methodStreamController =
  new StreamController.broadcast();


  FlutterBleLib._() {
    _mainMethodChannel.setMethodCallHandler((MethodCall call) {
      _methodStreamController.add(call);
    });
  }


  Stream<ScanResult> scan({
    int scanMode,
    int callbackType,
  }) async* {
    var settings = bleData.ScanSettingsMessage.create()
      ..scanMode = scanMode
      ..callbackType = callbackType;

    StreamSubscription subscription;
    StreamController controller;

    controller = new StreamController(
      onListen: () {
        new Future.delayed(new Duration(seconds: 10), () => controller.close());
      },
      onCancel: () {
        subscription.cancel();
      },
    );

    await _mainMethodChannel.invokeMethod(scanDevices, settings.writeToBuffer());

    subscription = _scanDevicesChanel.receiveBroadcastStream().listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );

    yield* controller.stream
        .map((List<int> data) => new bleData.ScanResultMessage.fromBuffer(data))
        .map((scanResultMessage) => ScanResult.fromMessage(scanResultMessage));
  }

  Future<Null> stopScan() => _mainMethodChannel.invokeMethod(stopScanDevices);
}
