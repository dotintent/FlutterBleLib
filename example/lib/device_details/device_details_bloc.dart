
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
//  SensorTagFactoryag _sensorTag;

  BehaviorSubject<BleDevice> _deviceController;

  ValueObservable<BleDevice> get device => _deviceController.stream;

  StreamSubscription connectionSubscription;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice.skipWhile((bleDevice) => bleDevice != null);

  DeviceDetailsBloc(this._deviceRepository, this._bleManager) {
    _deviceController =
        BehaviorSubject<BleDevice>.seeded(_deviceRepository.pickedDevice.value);

  }

  void init() {
    Fimber.d("init bloc");
    _deviceController.stream.listen((bleDevice) {
      Fimber.d("got bleDevice: $bleDevice");
      bleDevice.peripheral.isConnected()
        .then((isConnected) {
          if (!isConnected) {
            bleDevice.peripheral.connect().then((_) {
              _deviceController.add(BleDevice.connected(bleDevice));
            });
          }
        })
      .catchError((error) => Fimber.e("Connection problem", ex: error));

//      if (bleDevice.bluetoothDeviceState == BluetoothDeviceState.disconnected) {
//        _devicesInConnectingProcess = (bleDevice as DisconnectedBleDevice).connect();
//        _devicesInConnectingProcess.pipe(_deviceController);
//        return;
//      }
//    });
//    _deviceController.listen((BleDevice bleDevice) {
//      if (bleDevice is ConnectedBleDevice ) {
//        _sensorTag = _sensorTagFactory.create(bleDevice)..initAllSensors();
//        _sensorTag.ambientTemperature.pipe(_ambientTemperaturSubject);
//      }
//    });
    });
  }

  void disconnect() {
    _deviceController.stream.value.peripheral.disconnectOrCancelConnection()
    .then((_) { _deviceRepository.pickDevice(null); });
  }

  void dispose() async {
    _deviceController.value?.abandon();
    await _deviceController.drain();
    _deviceController.close();
  }

}