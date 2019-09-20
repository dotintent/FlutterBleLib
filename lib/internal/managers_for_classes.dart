import 'package:flutter_ble_lib/flutter_ble_lib.dart';

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
}

abstract class ManagerForService {
  Future<List<Characteristic>> characteristicsForService(Service service);
}