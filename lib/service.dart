part of flutter_ble_lib;

abstract class _ServiceMetadata {
  static const String uuid = "serviceUuid";
  static const String id = "id";
}

class Service {
  Peripheral peripheral;
  String uuid;
  int id;

  Service(this.uuid, this.peripheral);

  Service.fromJson(Map<String, dynamic> jsonObject, Peripheral peripheral)
      : peripheral = peripheral,
        uuid = jsonObject[_ServiceMetadata.uuid],
        id = jsonObject[_ServiceMetadata.id];
}
