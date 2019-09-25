import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/model/ble_device.dart';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_ble_lib_example/repository/device_repository.dart';
import 'package:rxdart/rxdart.dart';

class DeviceDetailsBloc {
  final BleManager _bleManager;
  final DeviceRepository _deviceRepository;

  BehaviorSubject<BleDevice> _deviceController;

  ValueObservable<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController;

  ValueObservable<PeripheralConnectionState> get connectionState =>
      _connectionStateController.stream;

  Subject<List<DebugLog>> _logsController;

  Observable<List<DebugLog>> get logs => _logsController.stream;

  StreamSubscription connectionSubscription;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice != null);

  DeviceDetailsBloc(this._deviceRepository, this._bleManager) {
    var device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    _connectionStateController =
        BehaviorSubject<PeripheralConnectionState>.seeded(device.isConnected
            ? PeripheralConnectionState.connected
            : PeripheralConnectionState.disconnected);

    _logsController = PublishSubject<List<DebugLog>>();
  }

  void init() {
    Fimber.d("init bloc");
    _deviceController.stream.listen((bleDevice) {
      Fimber.d("got bleDevice: $bleDevice");
      bleDevice.peripheral.isConnected().then((isConnected) {
        Fimber.d('The device is connected: $isConnected');
        if (!isConnected) {
          _connectTo(bleDevice);
        }
      }).catchError((error) => Fimber.e("Connection problem", ex: error));
    });
  }

  Future<void> disconnect() async {
    return _deviceController.stream.value.peripheral
        .disconnectOrCancelConnection()
        .then((_) {
      _deviceRepository.pickDevice(null);
    });
  }

  void dispose() async {
    _deviceController.value?.abandon();
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();
  }

  void _connectTo(BleDevice bleDevice) async {
    _bleManager.setLogLevel(LogLevel.debug);
    var peripheral = bleDevice.peripheral;
    peripheral
        .observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      Fimber.d('Observerd new connection state: $connectionState');
      _connectionStateController.add(connectionState);
    });

    Fimber.d('Try to connecto the device');
    await peripheral.connect();
    Fimber.d("Connected to the device");
    List<DebugLog> logs = [];
    Function log = (text) {
      logs.insert(0, DebugLog(DateTime.now().toString(), text));
      _logsController.add(logs);
    };

    peripheral
        .discoverAllServicesAndCharacteristics()
        .then((_) => peripheral.services())
        .then((services) {
          log("PRINTING SERVICES for ${peripheral.name}");
          services.forEach((service) => log("Found service ${service.uuid}"));
          return services.first;
        })
        .then((service) async {
          log("PRINTING CHARACTERISTICS FOR SERVICE \n${service.uuid}");
          List<Characteristic> characteristics =
              await service.characteristics();
          characteristics.forEach((characteristic) {
            log("${characteristic.uuid}");
          });

          log("PRINTING CHARACTERISTICS FROM \nPERIPHERAL for the same service");
          return peripheral.characteristics(service.uuid);
        })
        .then((characteristics) => characteristics.forEach((characteristic) =>
            log("Found characteristic \n ${characteristic.uuid}")))
        .then((_) async {
            int rssi = await peripheral.rssi();
            log("rssi $rssi");
        })
        .then((_) async {
          await peripheral.requestMtu(74);
          log("MTU requested");
        })
        .then((_) {
          log("WAITING 10 SECOND BEFORE DISCONNECTING");
          return Future.delayed(Duration(seconds: 10));
        })
        .then((_) {
          log("DISCONNECTING...");
          return peripheral.disconnectOrCancelConnection();
        })
        .then((_) {
          log("Disconnected!");
        });
  }
}

class DebugLog {
  String time;
  String content;

  DebugLog(this.time, this.content);
}
