part of flutter_ble_lib;

abstract class _ServiceMetadata {
  static const String uuid = "serviceUuid";
  static const String id = "serviceId";
}

class Service {
  Peripheral peripheral;
  ManagerForService _manager;
  String uuid;
  int _id;

  Service.fromJson(
    Map<String, dynamic> jsonObject,
    Peripheral peripheral,
    ManagerForService managerForService,
  )   : peripheral = peripheral,
        uuid = jsonObject[_ServiceMetadata.uuid],
        _manager = managerForService,
        _id = jsonObject[_ServiceMetadata.id];

  Future<List<Characteristic>> characteristics() =>
      _manager.characteristicsForService(this);

  Future<Characteristic> writeCharacteristic(
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _manager.writeCharacteristicForService(peripheral, _id,
          characteristicUUID, bytes, withResponse, transactionId);

  Future<Characteristic> readCharacteristic(String characteristicUUID,
          {String transactionId}) =>
      _manager.readCharacteristicForService(
        peripheral,
        _id,
        characteristicUUID,
        transactionId,
      );

  Stream<CharacteristicWithValue> monitorCharacteristic(
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.monitorCharacteristicForService(
        peripheral,
        _id,
        characteristicUUID,
        transactionId,
      );
}
