
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:flutter_ble_lib/src/util/_transaction_id_generator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ManagerForPeripheralMock extends Mock implements ManagerForPeripheral {}
class ServiceMock extends Mock implements Service {}
class CharacteristicMock extends Mock implements Characteristic {}
class TransactionIdGeneratorMock extends Mock implements TransactionIdGenerator {}
class CharacteristicWithValueMock extends Mock implements CharacteristicWithValue {}
class DescriptorMock extends Mock implements Descriptor {}
class DescriptorWithValueMock extends Mock implements DescriptorWithValue {}

void main() {

  const PERIPHERAL_NAME = 'Peripheral name';
  const PERIPHERAL_ID = 'peripheral id';
  const SERVICE_UUID = 's1';
  const CHARACTERISTIC_UUID = 'c1';
  const TRANSACTION_ID = 't1';
  const DESCRIPTOR_UUID = "d1";


  ManagerForPeripheralMock managerForPeripheral;
  TransactionIdGeneratorMock transactionIdGeneratorMock;
  Peripheral peripheral;

  setUp(() {
    Map<String, dynamic> json = {
      'name': PERIPHERAL_NAME,
      'id' : PERIPHERAL_ID
    };
    managerForPeripheral = ManagerForPeripheralMock();
    transactionIdGeneratorMock = TransactionIdGeneratorMock();
    peripheral = Peripheral.fromJson(json, managerForPeripheral, transactionIdGenerator: transactionIdGeneratorMock);
  });

  group("Connection", () {
    test('should pass defaut values to manager', () {
      //when
      peripheral.connect();

      //then
      verify(managerForPeripheral.connectToPeripheral(
          PERIPHERAL_ID,
          isAutoConnect: false,
          requestMtu: 0,
          refreshGatt: false,
          timeout: null
      ));
    });

    test('should pass given values to manager', () {
      //given
      var isAutoConnect = true;
      var mtu = 33;
      var refreshGatt = true;
      var timeout = Duration(days: 4);

      //when
      peripheral.connect(
        isAutoConnect: isAutoConnect,
        requestMtu: mtu,
        refreshGatt: refreshGatt,
        timeout: timeout
      );

      //then
      verify(managerForPeripheral.connectToPeripheral(
          PERIPHERAL_ID,
          isAutoConnect: isAutoConnect,
          requestMtu: mtu,
          refreshGatt: refreshGatt,
          timeout: timeout
      ));
    });

    test("should emit on every connection state change", () {
      //given
      var states = [
        PeripheralConnectionState.disconnected,
        PeripheralConnectionState.connecting,
        PeripheralConnectionState.connected
      ];
      when(managerForPeripheral.observePeripheralConnectionState(any, any, any))
          .thenAnswer((_) => Stream.fromIterable(states));

      //when
      Stream<PeripheralConnectionState> connectionStateStream =  peripheral.observeConnectionState();

      //then
      expect(connectionStateStream, emitsInOrder(states));
    });

    test("should pass arguments to manager for observing connection state", () {
      //given
      var emitCurrentValue = true;
      var completeOnDisconnect = true;

      //when
      peripheral.observeConnectionState(emitCurrentValue: emitCurrentValue, completeOnDisconnect: completeOnDisconnect);

      //then
      verify(managerForPeripheral.observePeripheralConnectionState(PERIPHERAL_ID, emitCurrentValue, completeOnDisconnect));
    });

    test('should call disconnect on manager with valid arguments', () {
      //when
      peripheral.disconnectOrCancelConnection();

      //then
      verify(managerForPeripheral.disconnectOrCancelPeripheralConnection(PERIPHERAL_ID));
    });

    [true, false].forEach((isConnected) {
      test("returns isConneted information based on $isConnected returned by manager", () async {
        //given
        when(managerForPeripheral.isPeripheralConnected(any))
            .thenAnswer((_) => Future.value(isConnected));

        //when
        bool peripheralIsConnected = await peripheral.isConnected();

        //then
        expect(peripheralIsConnected, isConnected);
      });
    });
  });

  group("Discovery", () {
    test("use given transactionId", () async {
      //when
      await peripheral.discoverAllServicesAndCharacteristics(transactionId: TRANSACTION_ID);

      //then
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, TRANSACTION_ID));
    });

    test("use generated transactionId", () async {
      //given
      var ids = ["1", "5"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.discoverAllServicesAndCharacteristics();
      await peripheral.discoverAllServicesAndCharacteristics();

      //then
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, '1'));
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, '5'));
    });
  });

  group("Services", () {
    test("should return services", () async {
      //given
      List<Service> services = [ServiceMock(), ServiceMock()];
      when(managerForPeripheral.services(any)).thenAnswer((_) => Future.value(services));

      //when
      List<Service> fetchedServices = await peripheral.services();

      //then
      expect(fetchedServices, services);
    });
  });

  group("Characteristics", () {
    test("should return characteristic for given service", () async {
      //given
      List<Characteristic> characteristics = [CharacteristicMock(), CharacteristicMock()];
      when(managerForPeripheral.characteristics(any, SERVICE_UUID)).thenAnswer((_) => Future.value(characteristics));

      //when
      List<Characteristic> fetchedCharacteristic = await peripheral.characteristics(SERVICE_UUID);

      //then
      expect(fetchedCharacteristic, characteristics);
    });

    test("schould return value of characteristic", () async {
      //given
      CharacteristicWithValue mockedCharacteristicWithValue  = CharacteristicWithValueMock();
      var transactionId = "t1";
      when(managerForPeripheral.readCharacteristicForDevice(any, any, any, transactionId))
        .thenAnswer((_) => Future.value(mockedCharacteristicWithValue));

      //when
      CharacteristicWithValue characteristicWithValue = await peripheral.readCharacteristic('s1', 'c1', transactionId: transactionId);

      //then
      expect(characteristicWithValue, mockedCharacteristicWithValue);
    });

    test("should use autogenerated transactionId during reading operation", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.readCharacteristic('s1', 'c1');
      await peripheral.readCharacteristic('s1', 'c1');

      //then
      verify(managerForPeripheral.readCharacteristicForDevice(any, any, any, '4'));
      verify(managerForPeripheral.readCharacteristicForDevice(any, any, any, '9'));
    });

    test("should write value to characteristic", () async {
      //given
      CharacteristicWithValue mockedCharacteristicWithValue  = CharacteristicWithValueMock();
      Uint8List value = Uint8List.fromList([1, 4, 9]);
      const withResponse = false;

      when(managerForPeripheral.writeCharacteristicForDevice(any, SERVICE_UUID, CHARACTERISTIC_UUID, value, withResponse, TRANSACTION_ID))
          .thenAnswer((_) => Future.value(mockedCharacteristicWithValue));

      //when
      CharacteristicWithValue characteristicWithValue = await peripheral.writeCharacteristic(SERVICE_UUID, CHARACTERISTIC_UUID, value, withResponse, transactionId: TRANSACTION_ID);

      //then
      expect(characteristicWithValue, mockedCharacteristicWithValue);
    });

    test("should use autogenerated transactionId during writing operation", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.writeCharacteristic('s1', 'c1', Uint8List.fromList([1]), false);
      await peripheral.writeCharacteristic('s1', 'c1', Uint8List.fromList([1]), false);

      //then
      verify(managerForPeripheral.writeCharacteristicForDevice(any, any, any, any, any, '4'));
      verify(managerForPeripheral.writeCharacteristicForDevice(any, any, any, any, any, '9'));
    });

    test("should return values of monitored characteristic", () {
      //given
      var emittedValues = [
        CharacteristicWithValueMock(),
        CharacteristicWithValueMock(),
        CharacteristicWithValueMock()
      ];
      when(managerForPeripheral.monitorCharacteristicForDevice(any, SERVICE_UUID, CHARACTERISTIC_UUID, TRANSACTION_ID))
          .thenAnswer((_) => Stream.fromIterable(emittedValues));

      //when
      Stream<CharacteristicWithValue> characteristicsStream =  peripheral.monitorCharacteristic(SERVICE_UUID, CHARACTERISTIC_UUID, transactionId: TRANSACTION_ID);

      //then
      expect(characteristicsStream, emitsInOrder(emittedValues));
    });

    test("should use autogenerated transactionId for monitoring operation", () {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
     peripheral.monitorCharacteristic('s1', 'c1');
     peripheral.monitorCharacteristic('s1', 'c1');

      //then
      verify(managerForPeripheral.monitorCharacteristicForDevice(any, any, any, '4'));
      verify(managerForPeripheral.monitorCharacteristicForDevice(any, any, any, '9'));
    });

  });

  group("Rssi", () {
    test("use given transactionId", () async {
      //given
      const transactionId = "86791384-";
      const rssi = 23;
      when(managerForPeripheral.rssi(any, transactionId)).thenAnswer((_) => Future.value(rssi));

      //when
      int obtainedRssi = await peripheral.rssi(transactionId: transactionId);

      //then
      verify(managerForPeripheral.rssi(any, transactionId));
      expect(obtainedRssi, rssi);
    });

    test("use generated transactionId", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.rssi();
      await peripheral.rssi();

      //then
      verify(managerForPeripheral.rssi(any, '4'));
      verify(managerForPeripheral.rssi(any, '9'));
    });
  });

  group("MTU", () {
    test("returns negotiated MTU", () async {
      //given
      const requestedMtu = 23;
      const negotiatedMtu = 135;
      when(managerForPeripheral.requestMtu(any, requestedMtu, any)).thenAnswer((_) => Future.value(negotiatedMtu));

      //when
      int obtainedMtu = await peripheral.requestMtu(requestedMtu);

      //then
      expect(negotiatedMtu, obtainedMtu);
    });

    test("use generated transactionId", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.requestMtu(23);
      await peripheral.requestMtu(45);

      //then
      verify(managerForPeripheral.requestMtu(any, any, '4'));
      verify(managerForPeripheral.requestMtu(any, any, '9'));
    });
  });

  group("Descriptor", () {
    test("should return desriptors of characteristic", () async {
      //given
      List<Descriptor> descriptors = [DescriptorMock(), DescriptorMock()];
      when(managerForPeripheral.descriptorsForPeripheral(any, SERVICE_UUID, CHARACTERISTIC_UUID)).thenAnswer((_) => Future.value(descriptors));

      //when
      List<Descriptor> fetchedDescriptors = await peripheral.descriptorsForCharacteristic(SERVICE_UUID, CHARACTERISTIC_UUID);

      //then
      expect(fetchedDescriptors, descriptors);
    });

    test("should return Descriptor value", () async {
      //given
      DescriptorWithValue descriptorWithValue  = DescriptorWithValueMock();
      const transactionId = "t1";
      when(managerForPeripheral.readDescriptorForPeripheral(any, SERVICE_UUID, CHARACTERISTIC_UUID, DESCRIPTOR_UUID, transactionId))
          .thenAnswer((_) => Future.value(descriptorWithValue));

      //when
      DescriptorWithValueMock obtainedDescriptorWithValue = await peripheral.readDescriptor(SERVICE_UUID, CHARACTERISTIC_UUID, DESCRIPTOR_UUID, transactionId: transactionId);

      //then
      expect(obtainedDescriptorWithValue, descriptorWithValue);
    });

    test("should use autogenerated transactionId during reading operation", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.readDescriptor('s1', 'c1', 'd1');
      await peripheral.readDescriptor('s1', 'c1', 'd1');

      //then
      verify(managerForPeripheral.readDescriptorForPeripheral(any, any, any, any, '4'));
      verify(managerForPeripheral.readDescriptorForPeripheral(any, any, any, any, '9'));
    });

    test("should write value to descriptor", () async {
      //given
      DescriptorWithValue descriptorWithValue  = DescriptorWithValueMock();
      Uint8List value = Uint8List.fromList([1, 4, 9]);

      when(managerForPeripheral.writeDescriptorForPeripheral(any, SERVICE_UUID, CHARACTERISTIC_UUID, DESCRIPTOR_UUID, value, TRANSACTION_ID))
          .thenAnswer((_) => Future.value(descriptorWithValue));

      //when
      DescriptorWithValue obtainedDescriptorWithValue = await peripheral.writeDescriptor(SERVICE_UUID, CHARACTERISTIC_UUID, DESCRIPTOR_UUID, value, transactionId: TRANSACTION_ID);

      //then
      expect(obtainedDescriptorWithValue, descriptorWithValue);
    });

    test("should use autogenerated transactionId during writing operation", () async {
      //given
      var ids = ["4", "9"];
      when(transactionIdGeneratorMock.getNextId()).thenAnswer((_) => ids.removeAt(0));

      //when
      await peripheral.writeDescriptor('s1', 'c1', 'd1', Uint8List.fromList([1]));
      await peripheral.writeDescriptor('s1', 'c1', 'd1', Uint8List.fromList([1]));

      //then
      verify(managerForPeripheral.writeDescriptorForPeripheral(any, any, any, any, any, '4'));
      verify(managerForPeripheral.writeDescriptorForPeripheral(any, any, any, any, any, '9'));
    });
  });


}