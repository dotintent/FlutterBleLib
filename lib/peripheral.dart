part of flutter_ble_lib;

abstract class _PeripheralMetadata {
  static const name = "name";
  static const identifier = "id";
}
/// Device instance represents BLE peripheral
class Peripheral {
  static const int NO_MTU_NEGOTIATION = 0;
  ManagerForPeripheral _manager;

  String name;
  String identifier;

  /// Creates Peripheral from JSON
  ///
  /// Creates peripheral from [json] and initializes it with [manager]
  Peripheral.fromJson(Map<String, dynamic> json, ManagerForPeripheral manager)
      : _manager = manager,
        name = json[_PeripheralMetadata.name],
        identifier = json[_PeripheralMetadata.identifier];

  /// Connects to the Device.
  ///
  /// Optional [isAutoConnect] controls whether to directly connect to the
  /// remote device (false) or to automatically connect as soon as the
  /// remote device becomes available (true). [Android only]
  /// Optional [requestMtu] size will be negotiated to this value. It is not
  /// guaranteed to get it after connection is successful. 0 passed as
  /// Optional [requestMtu] means that the MTU will not be negotiated
  /// Passing true as [refreshGatt] leads reset services cache. This option may
  /// be useful when a peripheral's firmware was updated and it's
  /// services/characteristics were added/removed/altered. [Android only]
  /// Optional [timeout] is used to define time after connection is
  /// automatically timed out. In case of race condition were connection
  /// is established right after timeout event, device will be disconnected
  /// immediately. Time out may happen earlier then specified due to OS
  /// specific behavior.
  Future<void> connect(
          {bool isAutoConnect = false,
          int requestMtu = NO_MTU_NEGOTIATION,
          bool refreshGatt = false,
          Duration timeout}) =>
      _manager.connectToPeripheral(identifier,
          isAutoConnect: isAutoConnect,
          requestMtu: requestMtu,
          refreshGatt: refreshGatt,
          timeout: timeout);

  /// Observe connection state
  ///
  /// Returns stream of [PeripheralConnectionState]
  Stream<PeripheralConnectionState> observeConnectionState(
          {bool emitCurrentValue = false, bool completeOnDisconnect = false}) =>
      _manager.observePeripheralConnectionState(
          identifier, emitCurrentValue, completeOnDisconnect);

  /// Returns whether peripheral is connected.
  Future<bool> isConnected() => _manager.isPeripheralConnected(identifier);

  /// Disconnects from this peripheral if it's connected or cancels pending connection.
  Future<void> disconnectOrCancelConnection() =>
      _manager.disconnectOrCancelPeripheralConnection(identifier);

  /// Discovers all Services, Characteristics and Descriptors for Device.
  ///
  /// Optional [transactionId] could be used to cancel operation.
  Future<void> discoverAllServicesAndCharacteristics({String transactionId}) =>
      _manager.discoverAllServicesAndCharacteristics(
          this, transactionId ?? TransactionIdGenerator.getNextId());

  /// List of discovered Services for the Device.
  Future<List<Service>> services() => _manager.services(this);

  /// List of discovered Characteristics for given Service.
  ///
  /// [servicedUuid] must be specified and characteristics only for that
  /// service are returned.
  Future<List<Characteristic>> characteristics(String servicedUuid) =>
      _manager.characteristics(this, servicedUuid);

  /// Reads RSSI for the device.
  ///
  /// Optional [transactionId] could be used to cancel operation.
  Future<int> rssi({String transactionId}) =>
      _manager.rssi(this, transactionId ?? TransactionIdGenerator.getNextId());

  /// Request new MTU value for this device. This function currently is not
  /// doing anything on iOS platform as MTU exchange is done automatically.
  ///
  /// Given [mtu] will be negotiated and the actual value is returned as future.
  /// Optional [transactionId] could be used to cancel operation.
  Future<int> requestMtu(int mtu, {String transactionId}) =>
      _manager.requestMtu(
          this, mtu, transactionId ?? TransactionIdGenerator.getNextId());

  /// Read characteristic value.
  ///
  /// Returns value of characteristic with [characteristicUUID] for service with
  /// [serviceUUID]. Optional [transactionId] could be used to cancel operation.
  Future<CharacteristicWithValue> readCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.readCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Write Characteristic value.
  ///
  /// Writes [bytes] to characteristic with [characteristicUUID] for service with
  /// [serviceUUID]. Optional [transactionId] could be used to cancel operation.
  Future<Characteristic> writeCharacteristic(
    String serviceUUID,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  }) =>
      _manager.writeCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        bytes,
        withResponse,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Fetch list of Descriptors
  ///
  /// Returns list of discovered Descriptors for given [serviceUuid] in specified
  /// characteristic with [characteristicUuid]
  Future<List<Descriptor>> descriptorsForCharacteristic(
    String serviceUuid,
    String characteristicUuid,
  ) =>
      _manager.descriptorsForPeripheral(this, serviceUuid, characteristicUuid);

  /// Read descriptor value
  ///
  /// Returns Descriptor object matching specified [serviceUuid],
  /// [characteristicUuid] and [descriptorUuid]. Latest value of Descriptor will
  /// be stored inside returned object. Optional [transactionId] could be used
  /// to cancel operation.
  Future<DescriptorWithValue> readDescriptor(
    String serviceUuid,
    String characteristicUuid,
    String descriptorUuid, {
    String transactionId,
  }) =>
      _manager.readDescriptorForPeripheral(
        this,
        serviceUuid,
        characteristicUuid,
        descriptorUuid,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Write Descriptor value.
  ///
  /// Write [value] to Descriptor specified by [serviceUuid],
  /// [characteristicUuid] and [descriptorUuid]. Returns Descriptor which saved
  /// passed value. Optional [transactionId] could be used to cancel operation.
  Future<Descriptor> writeDescriptor(
    String serviceUuid,
    String characteristicUuid,
    String descriptorUuid,
    Uint8List value, {
    String transactionId,
  }) =>
      _manager.writeDescriptorForPeripheral(
        this,
        serviceUuid,
        characteristicUuid,
        descriptorUuid,
        value,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  /// Monitor value changes of a Characteristic.
  ///
  /// Emits [CharacteristicWithValue] for every observed change of the
  /// characteristic specified by [serviceUUID] and [characteristicUUID]
  /// If notifications are enabled they will be used in favour of indications.
  /// Optional [transactionId] could be used to cancel operation. Unsubscribe
  /// from the stream cancels monitoring.
  Stream<CharacteristicWithValue> monitorCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  }) =>
      _manager.monitorCharacteristicForDevice(
        this,
        serviceUUID,
        characteristicUUID,
        transactionId ?? TransactionIdGenerator.getNextId(),
      );

  @override
  String toString() {
    return 'Peripheral{\n\tname: $name, \n\tidentifier: $identifier\n}';
  }
}

/// Enum covers all possible connection state
enum PeripheralConnectionState {
  connecting,
  connected,
  disconnected,
  disconnecting
}
