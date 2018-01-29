part of flutter_ble_lib;

class FlutterBleLib {

  static const int _minMTU = 23;
  static const int _maxMTU = 517;
  static const int _unknownRssi = -1;
  static FlutterBleLib _newInstance = new FlutterBleLib._();

  static FlutterBleLib get instance => _newInstance;

  static const MethodChannel _mainMethodChannel =
  const MethodChannel(flutter_ble_lib);

  static const EventChannel _scanDevicesChanel =
  const EventChannel(flutter_ble_lib_scanDevices);

  static const EventChannel _bluetoothStateChanel =
  const EventChannel(flutter_ble_lib_stateChange);


  static const EventChannel _deviceConnectionChanged =
  const EventChannel(flutter_ble_lib_deviceConnectionChange);

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

  Future<Null> cancelTransaction(String transactionId) =>
      _mainMethodChannel.invokeMethod(_cancelTransaction,
          bleData.SimpleTransactionMessage.create()
            ..transactionId = transactionId
      );

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
    subscription = _scanDevicesChanel.receiveBroadcastStream().listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );

    await _mainMethodChannel.invokeMethod(
        _startDeviceScan, settings.writeToBuffer());

    yield* controller.stream
        .map((List<int> data) => new bleData.ScanResultMessage.fromBuffer(data))
        .map((scanResultMessage) => ScanResult.fromMessage(scanResultMessage));
  }

  Future<Null> stopDeviceScan() =>
      _mainMethodChannel.invokeMethod(_stopDeviceScan);

  Future<BleDevice> connectToDevice(String macAddress,
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
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<bool> isDeviceConnected(String macAddress) {
    return _mainMethodChannel.invokeMethod(_isDeviceConnected, macAddress);
  }


  Stream<BleDevice> onDeviceConnectionChanged() {
    return _deviceConnectionChanged.receiveBroadcastStream()
        .map((data) => new bleData.BleDeviceMessage.fromBuffer(data))
        .map((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice> requestMTUForDevice(String macAddress, int mtu,
      String transactionId) async {
    bleData.RequestMtuTransactionMessage requestMtuTransactionMessage
    = bleData.RequestMtuTransactionMessage.create()
      ..transactionId = transactionId
      ..macAddress = macAddress
      ..mtu = mtu < _minMTU ? _minMTU : mtu > _maxMTU ? _minMTU : mtu;
    return await _mainMethodChannel.invokeMethod(
        _requestMTUForDevice, requestMtuTransactionMessage.writeToBuffer())
        .then((byteData) =>
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice> readRSSIForDevice(String macAddress,
      String transactionId) async {
    bleData.ReadRSSIForDeviceMessage readRSSIForDeviceMessage
    = bleData.ReadRSSIForDeviceMessage.create()
      ..transactionId = transactionId
      ..macAddress = macAddress;
    return await _mainMethodChannel.invokeMethod(
        _readRSSIForDevice, readRSSIForDeviceMessage.writeToBuffer())
        .then((byteData) =>
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice> cancelDeviceConnection(String macAddress) async {
    return await _mainMethodChannel.invokeMethod(_cancelDeviceConnection, macAddress)
        .then((byteData) =>
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice>  discoverAllServicesAndCharacteristicsForDevice(String macAddress) async {
    return await _mainMethodChannel.invokeMethod(_discoverAllServicesAndCharacteristicsForDevice, macAddress)
        .then((byteData) =>
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<List<BleService>> servicesForDevice(String id) async {
    return await _mainMethodChannel.invokeMethod(_servicesForDevice, id)
        .then((byteData) =>
    new bleData.ServiceMessages.fromBuffer(byteData))
        .then((serviceMessages) =>
    new List.generate(
        serviceMessages.serviceMessages.length,
            (int index) => BleService.fromMessage(serviceMessages.serviceMessages[index]))
    );
  }

  Future<List<Characteristic>> characteristicsForDevice(String deviceId, String serviceUUID) async =>
    await _invokeMethodCharacteristicFor(_characteristicsForDevice,<String, String> {
      'deviceId': deviceId,
      'serviceUUID': serviceUUID
    });

  Future<List<Characteristic>> characteristicsForService(int serviceIdentifier) async =>
     await _invokeMethodCharacteristicFor(_characteristicsForService, serviceIdentifier);

  Future<List<Characteristic>> _invokeMethodCharacteristicFor(String methodName, [dynamic arguments] ) {
    return _mainMethodChannel.invokeMethod(methodName, arguments)
        .then((byteData) =>
    new bleData.CharacteristicMessages.fromBuffer(byteData)
    ).then((characteristicMessages) =>
      new List.generate(
          characteristicMessages.characteristicMessage.length,
              (int index) => Characteristic.fromMessage(characteristicMessages.characteristicMessage[index]))
     );
  }

}
