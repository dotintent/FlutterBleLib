part of flutter_ble_lib;

abstract class _PeripheralMetadata {
  static const name = "deviceName";
  static const identifier = "deviceId";
}

class Peripheral {
  PeripheralManager _manager;

  String name;
  String identifier;

  Peripheral.fromJson(Map<String, dynamic> json, PeripheralManager manager)
      : _manager = manager,
        name = json[_PeripheralMetadata.name],
        identifier = json[_PeripheralMetadata.identifier];


  Future<void> connect(
          {bool isAutoConnect,
          int requestMtu,
          bool refreshGatt,
          Duration timeout}) =>
      _manager.connectToPeripheral(identifier,
          isAutoConnect: isAutoConnect,
          requestMtu: requestMtu,
          refreshGatt: refreshGatt,
          timeout: timeout);

  Stream<PeripheralConnectionState> observeConnectionState({bool emitCurrentValue}) =>
      _manager.observePeripheralConnectionState(identifier,
          emitCurrentValue: emitCurrentValue);

  Future<bool> isConnected() => _manager.isPeripheralConnected(identifier);

  Future<void> disconnectOrCancelConnection() =>
      _manager.disconnectOrCancelPeripheralConnection(identifier);
}
