class BluetoothLowEnergyManager {
  Future<void> createClient({String restoreStateIdentifier, Function(List<Device>) handleRestoredConnectedDevice}) async
  // Future<CentralManager> createCentralManager() //must create separate native client and whole communication stack; TODO down the road
  // Future<PeripheralManager> createPeripheralManager() //must create separate native client and whole communication stack; TODO down the road

  Future<void> destroyClient() async

  Future<void> enableRadio()
  Future<void> disableRadio()
  
  Future<void> cancelTransaction(String transactionId) async

  Future<void> setLogLevel(LogLevel logLevel)
  Future<LogLevel> logLevel()

  Future<BluetoothState> state()
  Stream<BluetoothState> observeState({bool emitCurrentValue = true})
}

// class CentralManager { //TODO down the road
//   Future<void> createClient({String restoreStateIdentifier, Function(List<Device>) handleRestoredConnectedDevice}) async
//   Future<void> destroyClient() async

//   Future<void> enableRadio()
//   Future<void> disableRadio()
  
//   Future<void> cancelTransaction(String transactionId) async

//   Future<void> setLogLevel(LogLevel logLevel)
//   Future<LogLevel> logLevel()

//   Future<BluetoothState> state()
//   Stream<BluetoothState> observeState({bool emitCurrentValue = true})

//   Stream<ScanResult> startDeviceScan({int scanMode = 0, int callbackType = 1, List<String> uuids = void}) async*
//   Future<void> stopDeviceScan() async

//   Future<List<Device>> devices(String[] ids)
//   Future<List<Device>> connectedDevicesWithServices(String[] serviceUUIDs)
// }

// class PeripheralManager {} //TODO down the road

class Peripheral { //was Device
  Future<Device> connect({ bool isAutoConnect, int requestMtu }) async
  Future<bool> isConnected() async
  Stream<ConnectionState> onConnectionStateChanged() //TODO: create connectionState enum
  Future<void> disconnectOrCancelConnection() async

  Future<int> requestMTU(int mtu, { String transactionId }) async
  Future<int> readRSSI({ String transactionId }) async

  Future<void>  discoverAllServicesAndCharacteristics({ String transactionId }) async
  Future<List<Service>> services() async
  Future<List<Characteristic>> characteristics(String serviceUUID) async
  Future<List<Descriptor>> descriptors(String serviceUUID, String characteristicUUID) async

  Future<Characteristic> writeCharacteristic(String serviceUUID, String characteristicUUID, Uint8List bytes, bool withResponse, { String transactionId }) async
  Future<Characteristic> readCharacteristic(String serviceUUID, String characteristicUUID, { String transactionId }) async
  Stream<MonitorCharacteristic> monitorCharacteristic(String serviceUUID, String characteristicUUID, { String transactionId })

  Future<Descriptor> writeDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, Uint8List bytes, { String transactionId }) async
  Future<Descriptor> readDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, { String transactionId }) async
}

class Service {
  Future<List<Characteristic>> characteristics() async
  Future<List<Descriptor> descriptors(String characteristicUUID) async

  Future<Characteristic> writeCharacteristic(String characteristicUUID, Uint8List bytes, bool withResponse, { String transactionId }) async
  Future<Characteristic> readCharacteristic(String characteristicUUID, { String transactionId }) async
  Stream<MonitorCharacteristic> monitorCharacteristic(String characteristicUUID, { String transactionId })

  Future<Descriptor> writeDescriptor(String characteristicUUID, String descriptorUUID, Uint8List bytes, { String transactionId }) async
  Future<Descriptor> readDescriptor(String characteristicUUID, String descriptorUUID, { String transactionId }) async
}

class Characteristic {
  Future<List<Descriptor> descriptors(String characteristicUUID) async

  Future<Characteristic> write(Uint8List bytes, bool withResponse, { String transactionId }) async
  Future<Characteristic> read({ String transactionId }) async
  Stream<MonitorCharacteristic> monitor({ String transactionId })

  Future<Descriptor> writeDescriptor(String descriptorUUID, Uint8List bytes, { String transactionId }) async
  Future<Descriptor> readDescriptor(String descriptorUUID, { String transactionId }) async
}

class Descriptor {
  Future<Descriptor> writeDescriptor(Uint8List bytes, { String transactionId }) async
  Future<Descriptor> readDescriptor({ String transactionId }) async
}