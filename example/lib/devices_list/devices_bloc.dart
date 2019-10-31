import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter_ble_lib_example/model/ble_device.dart';
import 'package:flutter_ble_lib_example/repository/device_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class DevicesBloc {
  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamController<BleDevice> _devicePickerController = StreamController<BleDevice>();

  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription _devicePickerSubscription;

  ValueObservable<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Sink<BleDevice> get devicePicker => _devicePickerController.sink;

  DeviceRepository _deviceRepository;
  BleManager _bleManager;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice.skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository, this._bleManager);

  void _handlePickedDevice(BleDevice bleDevice) {
    _deviceRepository.pickDevice(bleDevice);
  }

  void dispose() {
    Fimber.d("cancel _devicePickerSubscription");
    _devicePickerSubscription.cancel();
    _visibleDevicesController.close();
    _devicePickerController.close();
    _scanSubscription?.cancel();
  }

  void init() {
    Fimber.d("Init devices bloc");
    bleDevices.clear();
    _bleManager.createClient(
          restoreStateIdentifier: "example-restore-state-identifier",
          restoreStateAction: (peripherals) {
            peripherals?.forEach((peripheral) {
              Fimber.d("Restored peripheral: ${peripheral.name}");
            });
          }
        )
        .then((it) => startScan())
        .catchError((e) => Fimber.d("Couldn't create BLE client", ex: e));

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController = BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
    }

    if (_devicePickerController.isClosed) {
      _devicePickerController = StreamController<BleDevice>();
    }


    Fimber.d(" listen to _devicePickerController.stream");
    _devicePickerSubscription = _devicePickerController.stream.listen(_handlePickedDevice);
  }

  void startScan() {
    Fimber.d("Ble client created");
    _scanSubscription = _bleManager.startPeripheralScan().listen((ScanResult scanResult) {
      var bleDevice = BleDevice.notConnected(scanResult.peripheral.name, scanResult.peripheral.identifier, scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        Fimber.d(
            'found new device ${scanResult.advertisementData.localName} ${scanResult.peripheral.identifier}');
        bleDevices.add(bleDevice);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  Future<void> refresh() async {
    _scanSubscription.cancel();
    await _bleManager.stopDeviceScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    startScan();
  }
}
