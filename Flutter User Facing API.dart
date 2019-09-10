class BleManager {
  Future<Null> createClient(String restoreStateIdentifier) async
  Future<Null> destroyClient() async

  Future<Null> enableRadio()
  Future<Null> disableRadio()
  
  Future<Null> cancelTransaction(String transactionId) async

  Future<Null> setLogLevel(LogLevel logLevel)
  Future<LogLevel> logLevel()

  Future<BluetoothState> state()
  Stream<BluetoothState> onStateChange()

  Stream<ScanResult> startDeviceScan(int scanMode, int callbackType, List<String> uuids) async*
  Future<Null> stopDeviceScan() async

  Future<List<Device>> devices(String[] ids)
  Future<List<Device>> connectedDevicesWithServices(String[] serviceUUIDs)
}

class Device {
  Future<Device> connect({ bool isAutoConnect, int requestMtu }) async
  Future<bool> isConnected() async
  Stream<Device> onConnectionChanged()
  Future<Device> cancelConnection() async

  Future<bool> requestMTU(int mtu, String transactionId) async
  Future<int> readRSSI(String transactionId) async

  Future<Null>  discoverAllServicesAndCharacteristics() async
  Future<List<Service>> services() async
  Future<List<Characteristic>> characteristics(String serviceUUID) async
  Future<List<Descriptor>> descriptors(String serviceUUID, String characteristicUUID) async

  Future<Characteristic> writeCharacteristic(String serviceUUID, String characteristicUUID, List<int> bytes, bool withResponse, String transactionId) async
  Future<Characteristic> readCharacteristic(String serviceUUID, String characteristicUUID, String transactionId) async
  Stream<MonitorCharacteristic> monitorCharacteristic(String serviceUUID, String characteristicUUID, String transactionId)

  Future<Descriptor> writeDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, List<int> bytes, String transactionId) async
  Future<Descriptor> readDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, String transactionId) async
}

class Service {
  Future<List<Characteristic>> characteristics() async
  Future<List<Descriptor> descriptors(String characteristicUUID) async

  Future<Characteristic> writeCharacteristic(String characteristicUUID, List<int> bytes, bool withResponse, String transactionId) async
  Future<Characteristic> readCharacteristic(String characteristicUUID, String transactionId) async
  Stream<MonitorCharacteristic> monitorCharacteristic(String characteristicUUID, String transactionId)

  Future<Descriptor> writeDescriptor(String characteristicUUID, String descriptorUUID, List<int> bytes, String transactionId) async
  Future<Descriptor> readDescriptor(String characteristicUUID, String descriptorUUID, String transactionId) async
}

class Characteristic {
  Future<List<Descriptor> descriptors(String characteristicUUID) async

  Future<Characteristic> write(List<int> bytes, bool withResponse, String transactionId) async
  Future<Characteristic> read(String transactionId) async
  Stream<MonitorCharacteristic> monitor(String transactionId)

  Future<Descriptor> writeDescriptor(String descriptorUUID, List<int> bytes, String transactionId) async
  Future<Descriptor> readDescriptor(String descriptorUUID, String transactionId) async
}

class Descriptor {
  Future<Descriptor> writeDescriptor(List<int> bytes, String transactionId) async
  Future<Descriptor> readDescriptor(String transactionId) async
}