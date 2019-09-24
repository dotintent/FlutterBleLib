import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/internal/bridge/internal_bridge_lib.dart';

abstract class ManagerForPeripheral {
  Future<void> connectToPeripheral(String peripheralIdentifier,
      {bool isAutoConnect, int requestMtu, bool refreshGatt, Duration timeout});

  Future<bool> isPeripheralConnected(String peripheralIdentifier);

  Future<void> disconnectOrCancelPeripheralConnection(
      String peripheralIdentifier);

  Stream<PeripheralConnectionState> observePeripheralConnectionState(
      String peripheralIdentifier, bool emitCurrentValue);

  Future<void> discoverAllServicesAndCharacteristics(
      Peripheral peripheral, String transactionId);

  Future<List<Service>> services(Peripheral peripheral);

  Future<List<Characteristic>> characteristics(
      Peripheral peripheral, String serviceUuid);

  Future<CharacteristicWithValue> readCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUuid,
    String characteristicUUID,
    String transactionId,
  );

  Future<Characteristic> writeCharacteristicForDevice(
      Peripheral peripheral,
      String serviceUUID,
      String characteristicUUID,
      Uint8List bytes,
      bool withResponse,
      String transactionId);

  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
    Peripheral peripheral,
    String serviceUUID,
    String characteristicUUID,
    String transactionId,
  );
}

abstract class ManagerForService {
  Future<List<Characteristic>> characteristicsForService(Service service);

  Future<CharacteristicWithValue> readCharacteristicForService(
    Peripheral peripheral,
    InternalService service,
    String characteristicUUID,
    String transactionId,
  );

  Future<Characteristic> writeCharacteristicForService(
    Peripheral peripheral,
    InternalService service,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  );

  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    InternalService service,
    String characteristicUUID,
    String transactionId,
  );
}

abstract class ManagerForCharacteristic {
  Future<Uint8List> readCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  );

  Future<void> writeCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    Uint8List bytes,
    bool withResponse,
    String transactionId,
  );

  Stream<Uint8List> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  );
}
