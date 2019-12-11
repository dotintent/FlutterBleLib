part of flutter_ble_lib;

abstract class _ServiceMetadata {
  static const String uuid = "serviceUuid";
  static const String id = "serviceId";
}

class Service extends InternalService {
  Peripheral peripheral;
  ManagerForService _manager;
  String uuid;

  Service.fromJson(
    Map<String, dynamic> jsonObject,
    Peripheral peripheral,
    ManagerForService managerForService,
  ) : super(jsonObject[_ServiceMetadata.id]) {
    this.peripheral = peripheral;
    uuid = jsonObject[_ServiceMetadata.uuid];
    _manager = managerForService;
  }

  Future<List<Characteristic>> characteristics() =>
      _manager.characteristicsForService(this);

  Future<Characteristic> writeCharacteristic(
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _manager.writeCharacteristicForService(
          peripheral,
          this,
          characteristicUUID,
          bytes,
          withResponse,
          transactionId ?? TransactionIdGenerator.getNextId());

  Future<CharacteristicWithValue> readCharacteristic(String characteristicUUID,
          {String transactionId}) =>
      _manager.readCharacteristicForService(
        peripheral,
        this,
        characteristicUUID,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  Stream<CharacteristicWithValue> monitorCharacteristic(
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.monitorCharacteristicForService(
        peripheral,
        this,
        characteristicUUID,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          peripheral.identifier == other.peripheral.identifier &&
          uuid == other.uuid;

  @override
  int get hashCode => peripheral.hashCode ^ _manager.hashCode ^ uuid.hashCode;

  @override
  String toString() {
    return 'Service{peripheralId: ${peripheral.identifier}, uuid: $uuid}';
  }
}
