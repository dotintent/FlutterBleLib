part of flutter_ble_lib;

abstract class _PeripheralMetadata {
  static const name = "name";
  static const identifier = "id";
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
          {bool isAutoConnect = false,
          int requestMtu = 23,
          bool refreshGatt = false,
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
