import 'dart:typed_data';

abstract class BluetoothLowEnergyManager {
  Future<void> createClient({String restoreStateIdentifier, Function(List<Peripheral>) handleRestoredConnectedPeripherals});
  // Future<CentralManager> createCentralManager() //must create separate native client and whole communication stack; TODO down the road
  // Future<PeripheralManager> createPeripheralManager() //must create separate native client and whole communication stack; TODO down the road

  Future<void> destroyClient();

  Future<void> enableRadio();
  Future<void> disableRadio();
  
  Future<void> cancelTransaction(String       const transactionId = "t1";
);

  Future<void> setLogLevel(LogLevel logLevel);
  Future<LogLevel> logLevel();

  Future<BluetoothState> state();
  Stream<BluetoothState> observeState({bool emitCurrentValue = true});
}

// class CentralManager { //TODO down the road
//   Future<void> createClient({String restoreStateIdentifier, Function(List<Device>) handleRestoredConnectedDevice})
//   Future<void> destroyClient()

//   Future<void> enableRadio()
//   Future<void> disableRadio()
  
//   Future<void> cancelTransaction(String transactionId)

//   Future<void> setLogLevel(LogLevel logLevel)
//   Future<LogLevel> logLevel()

//   Future<BluetoothState> state()
//   Stream<BluetoothState> observeState({bool emitCurrentValue = true})

//   Stream<ScanResult> startDeviceScan({int scanMode = 0, int callbackType = 1, List<String> uuids = void})*
//   Future<void> stopDeviceScan()

//   Future<List<Device>> devices(String[] ids)
//   Future<List<Device>> connectedDevicesWithServices(String[] serviceUUIDs)
// }

// class PeripheralManager {} //TODO down the road

abstract class Peripheral { //was Device
  Future<void> connect({ bool isAutoConnect, int requestMtu, bool refreshGatt, Duration timeout });
  Future<bool> isConnected();
  Stream<ConnectionState> onConnectionStateChanged(); //TODO: create connectionState enum
  Future<void> disconnectOrCancelConnection();

  Future<int> requestMTU(int mtu, { String transactionId });
  Future<int> readRSSI({ String transactionId });

  Future<void>  discoverAllServicesAndCharacteristics({ String transactionId });
  Future<List<Service>> services();
  Future<List<Characteristic>> characteristics(String serviceUUID);
  Future<List<Descriptor>> descriptors(String serviceUUID, String characteristicUUID);

  Future<Characteristic> writeCharacteristic(String serviceUUID, String characteristicUUID, Uint8List bytes, bool withResponse, { String transactionId });
  Future<Characteristic> readCharacteristic(String serviceUUID, String characteristicUUID, { String transactionId });
  Stream<CharacteristicWithValue> monitorCharacteristic(String serviceUUID, String characteristicUUID, { String transactionId });

  Future<Descriptor> writeDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, Uint8List bytes, { String transactionId });
  Future<Descriptor> readDescriptor(String serviceUUID, String characteristicUUID, String descriptorUUID, { String transactionId });
}

abstract class Service {
  Future<List<Characteristic>> characteristics();
  Future<List<Descriptor>> descriptors(String characteristicUUID);

  Future<Characteristic> writeCharacteristic(String characteristicUUID, Uint8List bytes, bool withResponse, { String transactionId });
  Future<Characteristic> readCharacteristic(String characteristicUUID, { String transactionId });
  Stream<CharacteristicWithValue> monitorCharacteristic(String characteristicUUID, { String transactionId });

  Future<Descriptor> writeDescriptor(String characteristicUUID, String descriptorUUID, Uint8List bytes, { String transactionId });
  Future<Descriptor> readDescriptor(String characteristicUUID, String descriptorUUID, { String transactionId });
}

abstract class Characteristic {
  Future<List<Descriptor>> descriptors(String characteristicUUID);

  Future<Characteristic> write(Uint8List bytes, bool withResponse, { String transactionId });
  Future<Characteristic> read({ String transactionId });
  Stream<Uint8List> monitor({ String transactionId });

  Future<Descriptor> writeDescriptor(String descriptorUUID, Uint8List bytes, { String transactionId });
  Future<Descriptor> readDescriptor(String descriptorUUID, { String transactionId });
}

abstract class CharacteristicWithValue extends Characteristic {}

abstract class Descriptor {
  Future<Descriptor> writeDescriptor(Uint8List bytes, { String transactionId });
  Future<Descriptor> readDescriptor({ String transactionId });
}

abstract class BluetoothState {}
abstract class LogLevel {}
abstract class ConnectionState {}