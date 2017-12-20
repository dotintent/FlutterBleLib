part of flutter_ble_lib;

class FlutterBleLib {

  static const int _unknownRssi = -1;
  static FlutterBleLib _newInstance = new FlutterBleLib._();

  static FlutterBleLib get instance => _newInstance;

  static const MethodChannel _mainMethodChannel =
  const MethodChannel(flutter_ble_lib);

  static const EventChannel _scanDevicesChanel =
  const EventChannel(flutter_ble_lib_scanDevices);

  static const EventChannel _bluetoothStateChanel =
  const EventChannel(flutter_ble_lib_stateChange);

  final StreamController<MethodCall> _methodStreamController =
  new StreamController.broadcast();


  FlutterBleLib._() {
    _mainMethodChannel.setMethodCallHandler((MethodCall call) {
      _methodStreamController.add(call);
    });
  }

  Future<Null> createClient() =>
      _mainMethodChannel.invokeMethod(_createClient);

  Future<Null> destroyClient() =>
      _mainMethodChannel.invokeMethod(_destroyClient);

  Future<Null> setLogLevel(LogLevel logLevel) =>
      _mainMethodChannel.invokeMethod(
          _setLogLevel,
          LogLevelConverter
              .toMessage(logLevel)
              .name
      );

  Future<LogLevel> logLevel() =>
      _mainMethodChannel.invokeMethod(_logLevel)
          .then((logLevelByte) => bleData.LogLevelMessage.valueOf(logLevelByte))
          .then((logLevelMessage) =>
          LogLevelConverter.fromMessage(logLevelMessage));

  Future<BluetoothState> state() =>
      _mainMethodChannel.invokeMethod(_state)
          .then((bluetoothStateByte) =>
          bleData.BluetoothStateMessage.valueOf(bluetoothStateByte))
          .then((bluetoothStateMessage) =>
          BluetoothStateConverter.fromMessage(bluetoothStateMessage));

  Stream<BluetoothState> onStateChange() {
    return _bluetoothStateChanel.receiveBroadcastStream()
        .map((data) => bleData.BluetoothStateMessage.valueOf(data))
        .map((bluetoothStateMessage) =>
        BluetoothStateConverter.fromMessage(bluetoothStateMessage));
  }

  Stream<ScanResult> startDeviceScan(int scanMode, int callbackType) async* {
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

    await _mainMethodChannel.invokeMethod(
        _startDeviceScan, settings.writeToBuffer());

    subscription = _scanDevicesChanel.receiveBroadcastStream().listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );

    yield* controller.stream
        .map((List<int> data) => new bleData.ScanResultMessage.fromBuffer(data))
        .map((scanResultMessage) => ScanResult.fromMessage(scanResultMessage));
  }

  Future<Null> stopDeviceScan() =>
      _mainMethodChannel.invokeMethod(_stopDeviceScan);

  Future<ConnectedDevice> connectToDevice(String macAddress,
      {bool isAutoConnect,
        int requestMtu}) async {
    bleData.ConnectToDeviceDataMessage connectToDeviceDataMessage
    = new bleData.ConnectToDeviceDataMessage()
      ..macAddress = macAddress
      ..isAutoConnect = isAutoConnect ?? false
      ..requestMtu = requestMtu ?? _unknownRssi;
    return await _mainMethodChannel.invokeMethod(
        _connectToDevice, connectToDeviceDataMessage.writeToBuffer())
        .then((byteData) =>
    new bleData.ConnectedDeviceMessage.fromBuffer(byteData))
        .then((connectedDeviceMessage) =>
        ConnectedDevice.fromMessage(connectedDeviceMessage));
  }
}
