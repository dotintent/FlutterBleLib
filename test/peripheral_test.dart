
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib/src/_managers_for_classes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ManagerForPeripheralMock extends Mock implements ManagerForPeripheral {}

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

}