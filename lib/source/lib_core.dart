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

  static const EventChannel _monitorCharacteristicChanel =
  const EventChannel(flutter_ble_lib_monitorCharacteristicChange);

  static const EventChannel _deviceConnectionChange =
  const EventChannel(flutter_ble_lib_deviceConnectionChange);

  final StreamController<MethodCall> _methodStreamController =
  new StreamController.broadcast();


  FlutterBleLib._() {
    _mainMethodChannel.setMethodCallHandler((MethodCall call) {
      _methodStreamController.add(call);
    });
  }

  Future<Null> createClient(String restoreStateIdentifier) async {
    await _mainMethodChannel.invokeMethod(_createClient,
        <String, String>{_restoreStateIdentifier: restoreStateIdentifier});
    return;
  }

  Future<Null> destroyClient() async {
    await _mainMethodChannel.invokeMethod(_destroyClient);
    return;
  }

  Future<Null> cancelTransaction(String transactionId) async {
    await _mainMethodChannel.invokeMethod(_cancelTransaction,
        transactionId
    );
    return;
  }


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

  Stream<ScanResult> startDeviceScan(int scanMode, int callbackType, List<String> uuids) async* {
    var settings = bleData.ScanDataMessage.create()
      ..scanMode = scanMode
      ..callbackType = callbackType;
    if(uuids != null){
      uuids.forEach(settings.uuids.add);
    }
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
        .map((data) => new bleData.ScanResultMessage.fromBuffer(data))
        .map((scanResultMessage) => ScanResult.fromMessage(scanResultMessage));
  }

  Future<Null> stopDeviceScan() async {
    await _mainMethodChannel.invokeMethod(_stopDeviceScan);
    return;
  }

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

  Future<bool> isDeviceConnected(String macAddress) async {
    final bool isConnected = await _mainMethodChannel.invokeMethod(_isDeviceConnected, macAddress);
    return isConnected;
  }


  Stream<BleDevice> onDeviceConnectionChanged() {
    return _deviceConnectionChange.receiveBroadcastStream()
        .map((data) => new bleData.BleDeviceMessage.fromBuffer(data))
        .map((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice> requestMTUForDevice(String deviceId, int mtu,
      String transactionId) async {
    return await _mainMethodChannel.invokeMethod(_requestMTUForDevice,
        <String, Object>{
          _deviceId: deviceId,
          _transactionId: transactionId,
          _mtu: mtu < _minMTU ? _minMTU : mtu > _maxMTU ? _minMTU : mtu
        }
    )
        .then((byteData) =>
    new bleData.BleDeviceMessage.fromBuffer(byteData))
        .then((bleDeviceMessage) =>
        BleDevice.fromMessage(bleDeviceMessage));
  }

  Future<BleDevice> readRSSIForDevice(String deviceId,
      String transactionId) async {
    return await _mainMethodChannel.invokeMethod(_readRSSIForDevice,
        <String, String>{
          _deviceId: deviceId,
          _transactionId: transactionId,
        }
    )
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
      _deviceId: deviceId,
      _serviceUUID : serviceUUID
    });

  Future<List<Characteristic>> characteristicsForService(double serviceIdentifier) async =>
     await _invokeMethodCharacteristicFor(_characteristicsForService, <String, Object> {
      _serviceIdentifier: serviceIdentifier
     });

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

  Future<Characteristic> writeCharacteristicForDevice(
      String deviceId,
      String serviceUUID,
      String characteristicUUID,
      List<int> bytes,
      bool response,
      String transactionId,) async =>
      await _invokeMethodWriteCharacteristic(
          _writeCharacteristicForDevice, <String, Object>{
        _deviceId: deviceId,
        _serviceUUID: serviceUUID,
        _characteristicUUID: characteristicUUID,
        _valueBase64: base64.encode(bytes),
        _response: response,
        _transactionId: transactionId,
      });

  Future<Characteristic> writeCharacteristicForService(
      double serviceIdentifier,
      String characteristicUUID,
      List<int> bytes,
      bool response,
      String transactionId,) async =>
      await _invokeMethodWriteCharacteristic(
          _writeCharacteristicForService, <String, Object>{
        _serviceIdentifier: serviceIdentifier,
        _characteristicUUID: characteristicUUID,
        _valueBase64: base64.encode(bytes),
        _response: response,
        _transactionId: transactionId,
      });

  Future<Characteristic> writeCharacteristic(
      double characteristicIdentifier,
      List<int> bytes,
      bool response,
      String transactionId,) async =>
      await _invokeMethodWriteCharacteristic(
          _writeCharacteristic, <String, Object>{
        _characteristicIdentifier: characteristicIdentifier,
        _valueBase64: base64.encode(bytes),
        _response: response,
        _transactionId: transactionId,
  });

  Future<Characteristic> _invokeMethodWriteCharacteristic(String methodName, [dynamic arguments]) {
    return _mainMethodChannel.invokeMethod(methodName, arguments)
        .then((byteData) => new bleData.CharacteristicMessage.fromBuffer(byteData))
        .then((characteristicMessage) => Characteristic.fromMessage(characteristicMessage));
  }

  Future<Characteristic> readCharacteristicForDevice(
      String deviceId,
      String serviceUUID,
      String characteristicUUID,
      String transactionId,) async =>
      await _invokeMethodReadCharacteristic(
          _readCharacteristicForDevice, <String, String>{
        _deviceId: deviceId,
        _serviceUUID: serviceUUID,
        _characteristicUUID: characteristicUUID,
        _transactionId: transactionId,
      });


  Future<Characteristic> readCharacteristicForService(
      double serviceIdentifier,
      String characteristicUUID,
      String transactionId,) async =>
      await _invokeMethodReadCharacteristic(
          _readCharacteristicForService, <String, Object>{
        _serviceIdentifier: serviceIdentifier,
        _characteristicUUID: characteristicUUID,
        _transactionId: transactionId,
      });

  Future<Characteristic> readCharacteristic(
      double characteristicIdentifier,
      String transactionId,) async =>
      await _invokeMethodReadCharacteristic(
          _readCharacteristic, <String, Object>{
        _characteristicIdentifier: characteristicIdentifier,
        _transactionId: transactionId,
      });

  Future<Characteristic> _invokeMethodReadCharacteristic(String methodName, [dynamic arguments]) {
    return _mainMethodChannel.invokeMethod(methodName, arguments)
        .then((byteData) => new bleData.CharacteristicMessage.fromBuffer(byteData))
        .then((characteristicMessage) => Characteristic.fromMessage(characteristicMessage));
  }

  Stream<MonitorCharacteristic> monitorCharacteristicForDevice(String deviceId,
      String serviceUUID, String characteristicUUID, String transactionId) =>
    _invokeMonitorCharacteristic(_monitorCharacteristicForDevice, <String, String> {
      _deviceId : deviceId,
      _serviceUUID : serviceUUID,
      _characteristicUUID : characteristicUUID,
      _transactionId : transactionId
    });

  Stream<MonitorCharacteristic> monitorCharacteristicForService(
      double serviceIdentifier, String characteristicUUID, String transactionId) =>
      _invokeMonitorCharacteristic(_monitorCharacteristicForService, <String, Object> {
        _serviceIdentifier : serviceIdentifier,
        _characteristicUUID : characteristicUUID,
        _transactionId : transactionId
      });

  Stream<MonitorCharacteristic> monitorCharacteristic(int characteristicIdentifier, String transactionId) =>
      _invokeMonitorCharacteristic(_monitorCharacteristic, <String, Object> {
        _characteristicIdentifier : characteristicIdentifier,
        _transactionId : transactionId
      });

  Stream<MonitorCharacteristic> _invokeMonitorCharacteristic(String methodName, [dynamic arguments]) async* {
    StreamSubscription subscription;
    StreamController controller;

    controller = new StreamController(
      onCancel: () {
        subscription.cancel();
      },
    );
    subscription = _monitorCharacteristicChanel.receiveBroadcastStream().listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    await _mainMethodChannel.invokeMethod(methodName, arguments);

    yield* controller.stream
        .map((data) => new bleData.MonitorCharacteristicMessage.fromBuffer(data))
        .map((monitorCharacteristicMessage) =>  MonitorCharacteristic.fromMessage(monitorCharacteristicMessage));
  }
}
