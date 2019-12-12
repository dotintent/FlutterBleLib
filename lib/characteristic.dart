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

class Characteristic extends InternalCharacteristic {
  Service service;
  ManagerForCharacteristic _manager;
  String uuid;
  bool isReadable;
  bool isWritableWithResponse;
  bool isWritableWithoutResponse;
  bool isNotifiable;
  bool isIndicatable;

  Characteristic.fromJson(Map<String, dynamic> jsonObject, Service service,
      ManagerForCharacteristic manager)
      : super(jsonObject[_CharacteristicMetadata.id]) {
    _manager = manager;
    this.service = service;
    uuid = jsonObject[_CharacteristicMetadata.uuid];
    isReadable = jsonObject[_CharacteristicMetadata.isReadable];
    isWritableWithResponse =
        jsonObject[_CharacteristicMetadata.isWritableWithResponse];
    isWritableWithoutResponse =
        jsonObject[_CharacteristicMetadata.isWritableWithoutResponse];
    isNotifiable = jsonObject[_CharacteristicMetadata.isNotifiable];
    isIndicatable = jsonObject[_CharacteristicMetadata.isIndicatable];
  }

  Future<Uint8List> read({String transactionId}) =>
      _manager.readCharacteristicForIdentifier(
        service.peripheral,
        this,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  Future<void> write(
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _manager.writeCharacteristicForIdentifier(
        service.peripheral,
        this,
        bytes,
        withResponse,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  Stream<Uint8List> monitor({String transactionId}) =>
      _manager.monitorCharacteristicForIdentifier(
        service.peripheral,
        this,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Characteristic &&
          runtimeType == other.runtimeType &&
          service == other.service &&
          _manager == other._manager &&
          uuid == other.uuid &&
          isReadable == other.isReadable &&
          isWritableWithResponse == other.isWritableWithResponse &&
          isWritableWithoutResponse == other.isWritableWithoutResponse &&
          isNotifiable == other.isNotifiable &&
          isIndicatable == other.isIndicatable;

  @override
  int get hashCode =>
      service.hashCode ^
      _manager.hashCode ^
      uuid.hashCode ^
      isReadable.hashCode ^
      isWritableWithResponse.hashCode ^
      isWritableWithoutResponse.hashCode ^
      isNotifiable.hashCode ^
      isIndicatable.hashCode;

  @override
  String toString() {
    return 'Characteristic{service: $service, _manager: $_manager, uuid: $uuid, isReadable: $isReadable, isWritableWithResponse: $isWritableWithResponse, isWritableWithoutResponse: $isWritableWithoutResponse, isNotifiable: $isNotifiable, isIndicatable: $isIndicatable}';
  }
}

mixin WithValue on Characteristic {
  Uint8List value;
}

class CharacteristicWithValue extends Characteristic with WithValue {
  CharacteristicWithValue.fromJson(
    Map<String, dynamic> jsonObject,
    Service service,
    ManagerForCharacteristic manager,
  ) : super.fromJson(jsonObject, service, manager) {
    value = base64Decode(jsonObject[_CharacteristicMetadata.value]);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        super == other &&
            other is CharacteristicWithValue &&
            value?.toString() == other.value?.toString() &&
            runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return super.toString() + ' CharacteristicWithValue{value = ${value.toString()}';
  }
}
