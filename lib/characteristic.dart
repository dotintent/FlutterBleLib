part of flutter_ble_lib;

abstract class _CharacteristicMetadata {
  static const String uuid = "characteristicUuid";
  static const String id = "id";
  static const String isReadable = "isReadable";
  static const String isWritableWithResponse = "isWritableWithResponse";
  static const String isWritableWithoutResponse = "isWritableWithoutResponse";
  static const String isNotifiable = "isNotifiable";
  static const String isIndicatable = "isIndicatable";
  static const String value = "value";
}

class Characteristic {
  Service service;
  String uuid;
  int id;
  bool isReadable;
  bool isWritableWithResponse;
  bool isWritableWithoutResponse;
  bool isNotifiable;
  bool isIndicatable;

  Characteristic(this.uuid, this.service, this.id,
      {this.isReadable,
      this.isWritableWithResponse,
      this.isWritableWithoutResponse,
      this.isNotifiable,
      this.isIndicatable});

  Characteristic.fromJson(Map<String, dynamic> jsonObject, Service service)
      : service = service,
        uuid = jsonObject[_CharacteristicMetadata.uuid],
        isReadable = jsonObject[_CharacteristicMetadata.isReadable],
        isWritableWithResponse =
            jsonObject[_CharacteristicMetadata.isWritableWithResponse],
        isWritableWithoutResponse =
            jsonObject[_CharacteristicMetadata.isWritableWithoutResponse],
        isNotifiable = jsonObject[_CharacteristicMetadata.isNotifiable],
        isIndicatable = jsonObject[_CharacteristicMetadata.isIndicatable];
}