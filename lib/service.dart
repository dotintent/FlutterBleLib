part of flutter_ble_lib;

abstract class _ServiceMetadata {
  static const String uuid = "serviceUuid";
  static const String id = "serviceId";
}

/// A collection of [Characteristic] and associated behaviors.
class Service extends InternalService {
  /// The peripheral to which this service belongs.
  Peripheral peripheral;

  ManagerForService _manager;

  /// The UUID of the service.
  String uuid;

  /// Deserializes [Service] from JSON for [peripheral] with
  /// [managerForService].
  Service.fromJson(
    Map<String, dynamic> jsonObject,
    Peripheral peripheral,
    ManagerForService managerForService,
  ) : super(jsonObject[_ServiceMetadata.id]) {
    this.peripheral = peripheral;
    uuid = jsonObject[_ServiceMetadata.uuid];
    _manager = managerForService;
  }

  /// Returns a list of characteristics of the service.
  Future<List<Characteristic>> characteristics() =>
      _manager.characteristicsForService(this);

  /// Writes the value in [bytes] of a [Characteristic] identified by
  /// [characteristicUUID].
  ///
  ///  It returns a [Future] that completes with the [Characteristic].
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

  /// Reads the value of a [Characteristic] identified by [characteristicUUID].
  ///
  /// It returns a [Future] that completes with [CharacteristicWithValue],
  /// which is just a [Characteristic] but with an additonal `value`
  /// property of type [Uint8List].
  Future<CharacteristicWithValue> readCharacteristic(
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.readCharacteristicForService(
        peripheral,
        this,
        characteristicUUID,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Returns a [Stream] of values emitted by a [Characteristic] identified by
  /// [characteristicUUID].
  ///
  /// Just like the [readCharacteristic()] method, values are emitted as
  /// [CharacteristicWithValue] objects, which are the same as [Characteristic]
  /// but with an additonal `value` property of type [Uint8List]. Only
  /// [Characteristic] with [Characteristic.isNotifiable] set as `true` can be
  /// monitored.
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

  /// Returns a list of descriptors of a [Characteristic] identified by
  /// [characteristicUuid].
  Future<List<Descriptor>> descriptorsForCharacteristic(
    String characteristicUuid,
  ) =>
      _manager.descriptorsForService(
        this,
        characteristicUuid,
      );

  /// Reads the value of a [Descriptor] identified by [descriptorUuid] of
  /// a [Characteristic] identified by [characteristicUuid].
  ///
  /// It returns a [Future] that completes with [DescriptorWithValue],
  /// which is just a [Descriptor] but with an additonal `value` property
  /// of type [Uint8List].
  Future<DescriptorWithValue> readDescriptor(
    String characteristicUuid,
    String descriptorUuid, {
    String transactionId,
  }) =>
      _manager.readDescriptorForService(
        this,
        characteristicUuid,
        descriptorUuid,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Writes the [value] of a [Descriptor] identified by [descriptorUuid]
  /// of a [Characteristic] identified by [characteristicUuid].
  ///
  /// It returns a [Future] that completes with the [Descriptor].
  Future<Descriptor> writeDescriptor(
    String characteristicUuid,
    String descriptorUuid,
    Uint8List value, {
    String transactionId,
  }) =>
      _manager.writeDescriptorForService(
        this,
        characteristicUuid,
        descriptorUuid,
        value,
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

  /// Returns a string representation of this object in a format that exposes
  /// [Peripheral.identifier] and [uuid].
  @override
  String toString() {
    return 'Service{peripheralId: ${peripheral.identifier}, uuid: $uuid}';
  }
}
