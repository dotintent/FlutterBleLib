
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ManagerForPeripheralMock extends Mock implements ManagerForPeripheral {}
class ServiceMock extends Mock implements Service {}
class CharacteristicMock extends Mock implements Characteristic {}

void main() {

  const PERIPHERAL_NAME = 'Peripheral name';
  const PERIPHERAL_ID = 'peripheral id';

  ManagerForPeripheralMock managerForPeripheral = ManagerForPeripheralMock();
  Peripheral peripheral;

  setUp(() {
    Map<String, dynamic> json = {
      'name': PERIPHERAL_NAME,
      'id' : PERIPHERAL_ID
    };
    peripheral = Peripheral.fromJson(json, managerForPeripheral);
  });

  group("Connect", () {
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
  });

  group("Observe connection state", () {
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

    test("should pass arguments to manager", () {
      //given
      var emitCurrentValue = true;
      var completeOnDisconnect = true;

      //when
      peripheral.observeConnectionState(emitCurrentValue: emitCurrentValue, completeOnDisconnect: completeOnDisconnect);

      //then
      verify(managerForPeripheral.observePeripheralConnectionState(PERIPHERAL_ID, emitCurrentValue, completeOnDisconnect));
    });
  });

  group("Connection checking", () {
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
      //given
      const transactionId = "86791384-";

      //when
      await peripheral.discoverAllServicesAndCharacteristics(transactionId: transactionId);

      //then
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, transactionId));
    });

    test("use generated transactionId", () async {
      //when
      await peripheral.discoverAllServicesAndCharacteristics();
      await peripheral.discoverAllServicesAndCharacteristics();

      //then
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, '1'));
      verify(managerForPeripheral.discoverAllServicesAndCharacteristics(any, '2'));
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
      const serviceUuid = "123uuid";
      when(managerForPeripheral.characteristics(any, serviceUuid)).thenAnswer((_) => Future.value(characteristics));

      //when
      List<Characteristic> fetchedCharacteristic = await peripheral.characteristics(serviceUuid);

      //then
      expect(fetchedCharacteristic, characteristics);
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
      //when
      await peripheral.rssi();
      await peripheral.rssi();

      //then
      verify(managerForPeripheral.rssi(any, '1'));
      verify(managerForPeripheral.rssi(any, '2'));
    });
  });

}