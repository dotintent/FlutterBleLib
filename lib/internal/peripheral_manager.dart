part of flutter_ble_lib;

abstract class PeripheralManager {
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
