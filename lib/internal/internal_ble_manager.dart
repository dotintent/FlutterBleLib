import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/internal/managers_for_classes.dart';
import 'package:flutter_ble_lib/internal/constants.dart';
import 'package:flutter_ble_lib/internal/bridge/internal_bridge_lib.dart';

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
  Stream<ScanResult> startPeripheralScan({
    int scanMode = ScanMode.lowPower,
    int callbackType = CallbackType.allMatches,
    List<String> uuids,
  }) =>
      _bleLib.startDeviceScan(scanMode, callbackType, uuids);

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
  ) =>
      _bleLib.observePeripheralConnectionState(
          peripheralIdentifier, emitCurrentValue);

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
  Future<CharacteristicWithValue> readCharacteristicForIdentifier(
          Peripheral peripheral, int characteristicIdentifier,
          String transactionId) =>
      _bleLib.readCharacteristicForIdentifier(
          peripheral, characteristicIdentifier,
          transactionId);

  @override
  Future<CharacteristicWithValue> readCharacteristicForDevice(
          Peripheral peripheral, String serviceUuid, String characteristicUUID,
          String transactionId) =>
      _bleLib.readCharacteristicForDevice(
        peripheral,
        serviceUuid,
        characteristicUUID,
        transactionId,
      );

  @override
  Future<CharacteristicWithValue> readCharacteristicForService(
          Peripheral peripheral,
          int serviceIdentifier,
          String characteristicUUID,
          String transactionId) =>
      _bleLib.readCharacteristicForService(
        peripheral,
        serviceIdentifier,
        characteristicUUID,
        transactionId,
      );

  @override
  Future<CharacteristicWithValue> writeCharacteristicForIdentifier(Peripheral peripheral,
          int characteristicIdentifier, Uint8List bytes, bool withResponse,
          String transactionId) =>
      _bleLib.writeCharacteristicForIdentifier(
        peripheral,
        characteristicIdentifier,
        bytes,
        withResponse,
        transactionId,
      );

  @override
  Future<CharacteristicWithValue> writeCharacteristicForDevice(
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
  Future<CharacteristicWithValue> writeCharacteristicForService(
          Peripheral peripheral,
          int serviceIdentifier,
          String characteristicUUID,
          Uint8List bytes,
          bool withResponse,
          String transactionId) =>
      _bleLib.writeCharacteristicForService(
        peripheral,
        serviceIdentifier,
        characteristicUUID,
        bytes,
        withResponse,
        transactionId,
      );

  @override
  Stream<CharacteristicWithValue> monitorCharacteristicForDevice(
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
  Stream<CharacteristicWithValue> monitorCharacteristicForService(
    Peripheral peripheral,
    int serviceIdentifier,
    String characteristicUUID,
    String transactionId,
  ) =>
      _bleLib.monitorCharacteristicForService(
        peripheral,
        serviceIdentifier,
        characteristicUUID,
        transactionId,
      );

  @override
  Stream<CharacteristicWithValue> monitorCharacteristicForIdentifier(
    Peripheral peripheral,
    int characteristicIdentifier,
    String transactionId,
  ) =>
      _bleLib.monitorCharacteristicForIdentifier(
        peripheral,
        characteristicIdentifier,
        transactionId,
      );
}
