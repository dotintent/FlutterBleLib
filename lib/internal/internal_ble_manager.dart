part of internal_bridge_lib;

class InternalBleManager
    implements
        BleManager,
        ManagerForPeripheral,
        ManagerForService,
        ManagerForCharacteristic {
  FlutterBleLib _bleLib;

  InternalBleManager() {
    _bleLib = FlutterBleLib();
    _bleLib.registerManager(this);
  }

  @override
  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  }) {
    if (restoreStateAction != null) {
      _bleLib.restoredState().then((devices) {
        restoreStateAction(devices);
      });
    }
    return _bleLib.createClient(restoreStateIdentifier);
  }

  @override
  Future<void> destroyClient() => _bleLib.destroyClient();

  @override
  Future<void> cancelTransaction(String transactionId) =>
      _bleLib.cancelTransaction(transactionId);

  @override
  Future<void> enableRadio({String transactionId}) =>
      _bleLib.enableRadio(transactionId);

  @override
  Future<void> disableRadio({String transactionId}) =>
      _bleLib.disableRadio(transactionId);

  @override
  Future<BluetoothState> bluetoothState() => _bleLib.state();

  @override
  Stream<BluetoothState> observeBluetoothState({bool emitCurrentValue = true}) =>
      _bleLib.observeBluetoothState(emitCurrentValue);

  @override
  Stream<ScanResult> startPeripheralScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
    bool allowDuplicates = false,
  }) =>
      _bleLib.startDeviceScan(scanMode, callbackType, uuids ?? [], allowDuplicates);

  @override
  Future<void> stopDeviceScan() => _bleLib.stopDeviceScan();

  @override
  Future<void> connectToPeripheral(
    String identifier, {
    bool isAutoConnect,
    int requestMtu,
    bool refreshGatt,
    Duration timeout,
  }) async =>
      _bleLib.connectToPeripheral(
          identifier, isAutoConnect, requestMtu, refreshGatt, timeout);

  @override
  Stream<PeripheralConnectionState> observePeripheralConnectionState(
    String peripheralIdentifier,
    bool emitCurrentValue,
    bool completeOnDisconnect
  ) {

    var streamTransformer = StreamTransformer<PeripheralConnectionState, PeripheralConnectionState>.fromHandlers(
        handleData: (PeripheralConnectionState data, EventSink sink) {
          sink.add(data);
          if (data == PeripheralConnectionState.disconnected) {
            sink.close();
          }
        },
        handleError: (Object error, StackTrace stacktrace, EventSink sink) {
          sink.addError(error);
        },
        handleDone: (EventSink sink) => sink.close());

    var stream =  _bleLib.observePeripheralConnectionState(
        peripheralIdentifier, emitCurrentValue);
    if (completeOnDisconnect) {
      return stream.transform(streamTransformer);
    } else {
      return stream;
    }
  }

  @override
  Future<void> disconnectOrCancelPeripheralConnection(
          String peripheralIdentifier) =>
      _bleLib.disconnectOrCancelPeripheralConnection(peripheralIdentifier);

  @override
  Future<bool> isPeripheralConnected(String peripheralIdentifier) =>
      _bleLib.isPeripheralConnected(peripheralIdentifier);

  @override
  Future<LogLevel> logLevel() {
    return _bleLib.logLevel();
  }

  @override
  Future<void> setLogLevel(LogLevel logLevel) {
    return _bleLib.setLogLevel(logLevel);
  }

  @override
  Future<List<Characteristic>> characteristics(
    Peripheral peripheral,
    String serviceUuid,
  ) =>
      _bleLib.characteristics(peripheral, serviceUuid);

  @override
  Future<List<Service>> services(Peripheral peripheral) =>
      _bleLib.services(peripheral);

  @override
  Future<void> discoverAllServicesAndCharacteristics(
    Peripheral peripheral,
    String transactionId,
  ) =>
      _bleLib.discoverAllServicesAndCharacteristics(peripheral, transactionId);

  @override
  Future<List<Characteristic>> characteristicsForService(Service service) =>
      _bleLib.characteristicsForService(service);

  @override
  Future<int> rssi(
    Peripheral peripheral,
    String transactionId,
  ) {
    print("call channel read RSSI");
    return _bleLib.rssi(peripheral, transactionId);
  }

  @override
  Future<void> requestMtu(
      Peripheral peripheral, int mtu, String transactionId) {
    return _bleLib.requestMtu(peripheral, mtu, transactionId);
  }

  @override
  Future<List<Peripheral>> knownDevices(List<String> peripheralIdentifiers) {
    return _bleLib.knownDevices(peripheralIdentifiers ?? []);
  }

  @override
  Future<List<Peripheral>> connectedDevices(List<String> serviceUUIDs) {
    return _bleLib.connectedDevices(serviceUUIDs ?? []);
  }

  @override
  Future<Uint8List> readCharacteristicForIdentifier(
    Peripheral peripheral,
    InternalCharacteristic characteristic,
    String transactionId,
  ) =>
      _bleLib.readCharacteristicForIdentifier(
          peripheral, characteristic._id, transactionId);

  @override
  Future<CharacteristicWithValueWithTransactionId> readCharacteristicForDevice(
          Peripheral peripheral,
          String serviceUuid,
          String characteristicUUID,
          String transactionId) =>
      _bleLib.readCharacteristicForDevice(
        peripheral,
        serviceUuid,
        characteristicUUID,
        transactionId,
      );

  @override
  Future<CharacteristicWithValueWithTransactionId> readCharacteristicForService(
          Peripheral peripheral,
          InternalService service,
          String characteristicUUID,
          String transactionId) =>
      _bleLib.readCharacteristicForService(
        peripheral,
        service._id,
        characteristicUUID,
        transactionId,
      );

  @override
  Future<void> writeCharacteristicForIdentifier(
          Peripheral peripheral,
          InternalCharacteristic characteristic,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _bleLib.writeCharacteristicForIdentifier(
        peripheral,
        characteristic._id,
        bytes,
        withResponse,
        transactionId,
      );

  @override
  Future<Characteristic> writeCharacteristicForDevice(
          Peripheral peripheral,
          String serviceUUID,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _bleLib.writeCharacteristicForDevice(
        peripheral,
        serviceUUID,
        characteristicUUID,
        bytes,
        withResponse,
        transactionId,
      );

  @override
  Future<Characteristic> writeCharacteristicForService(
          Peripheral peripheral,
          InternalService service,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _bleLib.writeCharacteristicForService(
        peripheral,
        service._id,
        characteristicUUID,
        bytes,
        withResponse,
        transactionId,
      );

  @override
  Stream<CharacteristicWithValueWithTransactionId> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUUID,
    String characteristicUUID,
    String transactionId,
  ) =>
      _bleLib.monitorCharacteristicForDevice(
        peripheral,
        serviceUUID,
        characteristicUUID,
        transactionId,
      );

  @override
  Stream<CharacteristicWithValueWithTransactionId> monitorCharacteristicForService(
    Peripheral peripheral,
    InternalService service,
    String characteristicUUID,
    String transactionId,
  ) =>
      _bleLib.monitorCharacteristicForService(
        peripheral,
        service._id,
        characteristicUUID,
        transactionId,
      );

  @override
  Stream<Uint8List> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    InternalCharacteristic characteristic,
    String transactionId,
  ) =>
      _bleLib.monitorCharacteristicForIdentifier(
        peripheral,
        characteristic._id,
        transactionId,
      );
}
