import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:flutter_ble_lib_example/model/ble_device.dart';
import 'dart:typed_data';

import 'package:flutter_ble_lib_example/repository/device_repository.dart';
import 'package:flutter_ble_lib_example/test_scenarios/test_scenarios.dart';
import 'package:flutter_ble_lib_example/util/pair.dart';
import 'package:rxdart/rxdart.dart';

import '../sensor_tag_config.dart';

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
    List<DebugLog> logs = [];
    Logger log = (text) {
      logs.insert(0, DebugLog(DateTime.now().toString(), text));
      Fimber.d(text);
      _logsController.add(logs);
    };

    Logger logError = (text) {
      logs.insert(0,
          DebugLog(DateTime.now().toString(), "ERROR: ${text.toUpperCase()}"));
      Fimber.e(text);
      _logsController.add(logs);
    };

    log("Fetching log level");
    LogLevel logLevel = await _bleManager.logLevel();
    log("Current log level $logLevel");

    log("Setting log level to debug");
    await _bleManager.setLogLevel(LogLevel.debug);
    log("Set log level to debug");

    log("Fetching log level");
    logLevel = await _bleManager.logLevel();
    log("Current log level $logLevel");

    var peripheral = bleDevice.peripheral;
    peripheral
        .observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      log('Observed new connection state: $connectionState');
      _connectionStateController.add(connectionState);
    });

    SensorTagTestScenario(_bleManager, peripheral, log, logError).runTestScenario();
  }
}

class DebugLog {
  String time;
  String content;

  DebugLog(this.time, this.content);
}
