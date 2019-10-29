part of test_scenarios;

typedef TestedFunction = Future<void> Function();

class PeripheralTestOperations {
  final Peripheral peripheral;
  final Logger log;
  final Logger logError;
  StreamSubscription monitoringStreamSubscription;
  final BleManager bleManager;

  PeripheralTestOperations(
      this.bleManager, this.peripheral, this.log, this.logError);

  Future<void> connect() async {
    await _runWithErrorHandling(() async {
      log("Connecting to ${peripheral.name}");
      await peripheral.connect();
      log("Connected!");
    });
  }

  Future<void> cancelTransaction() async {
    await _runWithErrorHandling(() async {
      log("Starting operation to cancel...");
      peripheral
          .discoverAllServicesAndCharacteristics(transactionId: "test")
          .catchError((error) {
        BleError bleError = error as BleError;
        return logError("Cancelled operation caught an error: "
            "\nerror code ${bleError.errorCode},"
            "\nreason: ${bleError.reason}");
      });
      log("Operation to cancel started: discover all"
          " services and characteristics");

      log("Cancelling operation...");
      await bleManager.cancelTransaction("test");
      log("Operation cancelled!");
    });
  }

  Future<void> discovery() async {
    await _runWithErrorHandling(() async {
      await peripheral.discoverAllServicesAndCharacteristics();
      List<Service> services = await peripheral.services();
      log("PRINTING SERVICES for \n${peripheral.name}");
      services.forEach((service) => log("Found service \n${service.uuid}"));
      Service service = services.first;
      log("PRINTING CHARACTERISTICS FOR SERVICE \n${service.uuid}");

      List<Characteristic> characteristics = await service.characteristics();
      characteristics.forEach((characteristic) {
        log("${characteristic.uuid}");
      });

      log("PRINTING CHARACTERISTICS FROM \nPERIPHERAL for the same service");
      List<Characteristic> characteristicFromPeripheral =
          await peripheral.characteristics(service.uuid);
      characteristicFromPeripheral.forEach((characteristic) =>
          log("Found characteristic \n ${characteristic.uuid}"));
    });
  }

  Future<void> testReadingRssi() async {
    await _runWithErrorHandling(() async {
      int rssi = await peripheral.rssi();
      log("rssi $rssi");
    });
  }

  Future<void> testRequestingMtu() async {
    await _runWithErrorHandling(() async {
      int requestedMtu = 79;
      log("Requesting MTU = $requestedMtu");
      int negotiatedMtu = await peripheral.requestMtu(requestedMtu);
      log("negotiated MTU $negotiatedMtu");
    });
  }

  Future<void> readCharacteristicForPeripheral() async {
    await _runWithErrorHandling(() async {
      log("Reading temperature config");
      CharacteristicWithValue readValue = await peripheral.readCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Temperature config value: \n${_convertToTemperature(readValue.value)}C");
    });
  }

  Future<void> readCharacteristicForService() async {
    await _runWithErrorHandling(() async {
      log("Reading temperature config");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));
      CharacteristicWithValue readValue = await service.readCharacteristic(
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Temperature config value: \n${_convertToTemperature(readValue.value)}C");
    });
  }

  Future<void> readCharacteristic() async {
    await _runWithErrorHandling(() async {
      log("Reading temperature config");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      List<Characteristic> characteristics = await service.characteristics();
      Characteristic characteristic = characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid ==
              SensorTagTemperatureUuids.temperatureDataCharacteristic
                  .toLowerCase());

      Uint8List readValue = await characteristic.read();
      log("Temperature config value: \n${_convertToTemperature(readValue)}C");
    });
  }

  Future<void> writeCharacteristicForPeripheral() async {
    await _runWithErrorHandling(() async {
      Uint8List currentValue = await peripheral
          .readCharacteristic(SensorTagTemperatureUuids.temperatureService,
              SensorTagTemperatureUuids.temperatureConfigCharacteristic)
          .then((characteristic) => characteristic.value);

      int valueToSave;
      if (currentValue[0] == 0) {
        log("Turning on temperature update via peripheral");
        valueToSave = 1;
      } else {
        log("Turning off temperature update via peripheral");
        valueToSave = 0;
      }

      await peripheral.writeCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureConfigCharacteristic,
          Uint8List.fromList([valueToSave]),
          false);

      log("Written \"$valueToSave\" to temperature config");
    });
  }

  Future<void> writeCharacteristicForService() async {
    await _runWithErrorHandling(() async {
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      Uint8List currentValue = await service
          .readCharacteristic(
              SensorTagTemperatureUuids.temperatureConfigCharacteristic)
          .then((characteristic) => characteristic.value);

      int valueToSave;
      if (currentValue[0] == 0) {
        log("Turning on temperature update via service");
        valueToSave = 1;
      } else {
        log("Turning off temperature update via service");
        valueToSave = 0;
      }

      await service.writeCharacteristic(
          SensorTagTemperatureUuids.temperatureConfigCharacteristic,
          Uint8List.fromList([valueToSave]),
          false);

      log("Written \"$valueToSave\" to temperature config");
    });
  }

  Future<void> writeCharacteristic() async {
    await _runWithErrorHandling(() async {
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      List<Characteristic> characteristics = await service.characteristics();
      Characteristic characteristic = characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid ==
              SensorTagTemperatureUuids.temperatureConfigCharacteristic
                  .toLowerCase());
      Uint8List currentValue = await characteristic.read();
      int valueToSave;
      if (currentValue[0] == 0) {
        log("Turning on temperature update via characteristic");
        valueToSave = 1;
      } else {
        log("Turning off temperature update via characteristic");
        valueToSave = 0;
      }
      await characteristic.write(Uint8List.fromList([valueToSave]), false);
      log("Written \"$valueToSave\" to temperature config");
    });
  }

  Future<void> monitorCharacteristicForPeripheral() async {
    await _runWithErrorHandling(() async {
      log("Start monitoring temperature update");
      _startMonitoringTemperature(
          peripheral
              .monitorCharacteristic(
                  SensorTagTemperatureUuids.temperatureService,
                  SensorTagTemperatureUuids.temperatureDataCharacteristic,
                  transactionId: "monitor")
              .map((characteristic) => characteristic.value),
          log);
    });
  }

  Future<void> monitorCharacteristicForService() async {
    await _runWithErrorHandling(() async {
      log("Start monitoring temperature update");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));
      _startMonitoringTemperature(
          service
              .monitorCharacteristic(
                  SensorTagTemperatureUuids.temperatureDataCharacteristic,
                  transactionId: "monitor")
              .map((characteristic) => characteristic.value),
          log);
    });
  }

  Future<void> monitorCharacteristic() async {
    await _runWithErrorHandling(() async {
      log("Start monitoring temperature update");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      List<Characteristic> characteristics = await service.characteristics();
      Characteristic characteristic = characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid ==
              SensorTagTemperatureUuids.temperatureDataCharacteristic
                  .toLowerCase());

      _startMonitoringTemperature(
          characteristic.monitor(transactionId: "monitor"), log);
    });
  }

  Future<void> readWriteMonitorCharacteristicForPeripheral() async {
    await _runWithErrorHandling(() async {
      log("Test read/write/monitor characteristic on device");
      log("Start monitoring temperature");
      _startMonitoringTemperature(
        peripheral
            .monitorCharacteristic(SensorTagTemperatureUuids.temperatureService,
                SensorTagTemperatureUuids.temperatureDataCharacteristic,
                transactionId: "1")
            .map((characteristic) => characteristic.value),
        log,
      );
      log("Turning off temperature update");
      await peripheral.writeCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureConfigCharacteristic,
          Uint8List.fromList([0]),
          false);
      log("Turned off temperature update");

      log("Waiting one second for the reading");
      await Future.delayed(Duration(seconds: 1));

      log("Reading temperature");
      CharacteristicWithValue readValue = await peripheral.readCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Read temperature value ${_convertToTemperature(readValue.value)}C");

      log("Turning on temperature update");
      await peripheral.writeCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureConfigCharacteristic,
          Uint8List.fromList([1]),
          false);

      log("Turned on temperature update");

      log("Waiting 1 second for the reading");
      await Future.delayed(Duration(seconds: 1));
      log("Reading temperature");
      readValue = await peripheral.readCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Read temperature value ${_convertToTemperature(readValue.value)}C");

      log("Canceling temperature monitoring");
      await bleManager.cancelTransaction("1");
    });
  }

  Future<void> readWriteMonitorCharacteristicForService() async {
    await _runWithErrorHandling(() async {
      log("Test read/write/monitor characteristic on service");
      log("Fetching service");

      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      log("Start monitoring temperature");
      _startMonitoringTemperature(
        service
            .monitorCharacteristic(
                SensorTagTemperatureUuids.temperatureDataCharacteristic,
                transactionId: "2")
            .map((characteristic) => characteristic.value),
        log,
      );

      log("Turning off temperature update");
      await service.writeCharacteristic(
        SensorTagTemperatureUuids.temperatureConfigCharacteristic,
        Uint8List.fromList([0]),
        false,
      );
      log("Turned off temperature update");

      log("Waiting one second for the reading");
      await Future.delayed(Duration(seconds: 1));

      log("Reading temperature value");
      CharacteristicWithValue dataCharacteristic =
          await service.readCharacteristic(
              SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Read temperature value ${_convertToTemperature(dataCharacteristic.value)}C");

      log("Turning on temperature update");
      await service.writeCharacteristic(
          SensorTagTemperatureUuids.temperatureConfigCharacteristic,
          Uint8List.fromList([1]),
          false);
      log("Turned on temperature update");

      log("Waiting one second for the reading");
      await Future.delayed(Duration(seconds: 1));

      log("Reading temperature value");
      dataCharacteristic = await service.readCharacteristic(
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Read temperature value ${_convertToTemperature(dataCharacteristic.value)}C");
      log("Canceling temperature monitoring");
      await bleManager.cancelTransaction("2");
    });
  }

  Future<void> readWriteMonitorCharacteristic() async {
    await _runWithErrorHandling(() async {
      log("Test read/write/monitor characteristic on characteristic");

      log("Fetching service");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));

      log("Fetching config characteristic");
      List<Characteristic> characteristics = await service.characteristics();
      Characteristic configCharacteristic = characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid ==
              SensorTagTemperatureUuids.temperatureConfigCharacteristic
                  .toLowerCase());
      log("Fetching data characteristic");
      Characteristic dataCharacteristic = characteristics.firstWhere(
          (characteristic) =>
              characteristic.uuid ==
              SensorTagTemperatureUuids.temperatureDataCharacteristic
                  .toLowerCase());

      log("Start monitoring temperature");
      _startMonitoringTemperature(
        dataCharacteristic.monitor(transactionId: "3"),
        log,
      );

      log("Turning off temperature update");
      await configCharacteristic.write(Uint8List.fromList([0]), false);
      log("Turned off temperature update");

      log("Waiting one second for the reading");
      await Future.delayed(Duration(seconds: 1));

      log("Reading characteristic value");
      Uint8List value = await configCharacteristic.read();
      log("Read temperature config value \n$value");

      log("Turning on temperature update");
      await configCharacteristic.write(Uint8List.fromList([1]), false);
      log("Turned on temperature update");

      log("Waiting one second for the reading");
      await Future.delayed(Duration(seconds: 1));

      log("Reading characteristic value");
      value = await configCharacteristic.read();
      log("Read temperature config value \n$value");

      log("Canceling temperature monitoring");
      await bleManager.cancelTransaction("3");
    });
  }

  Future<void> disconnect() async {
    await _runWithErrorHandling(() async {
      log("WAITING 10 SECOND BEFORE DISCONNECTING");
      await Future.delayed(Duration(seconds: 10));
      log("DISCONNECTING...");
      await peripheral.disconnectOrCancelConnection();
      log("Disconnected!");
    });
  }

  Future<void> fetchConnectedDevice() async {
    await _runWithErrorHandling(() async {
      log("Fetch connected devices with no service specified");
      List<Peripheral> peripherals = await bleManager.connectedDevices([]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
      log("Fetch connected devices with temperature service");
      peripherals = await bleManager
          .connectedDevices([SensorTagTemperatureUuids.temperatureService]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
    });
  }

  Future<void> fetchKnownDevice() async {
    await _runWithErrorHandling(() async {
      log("Fetch known devices with no IDs specified");
      List<Peripheral> peripherals = await bleManager.knownDevices([]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
      log("Fetch known devices with one known device's ID specified");
      peripherals = await bleManager.knownDevices([peripheral.identifier]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
    });
  }

  void _startMonitoringTemperature(
      Stream<Uint8List> characteristicUpdates, Function log) async {
    await monitoringStreamSubscription?.cancel();
    monitoringStreamSubscription =
        characteristicUpdates.map(_convertToTemperature).listen(
      (temperature) {
        log("Temperature updated: ${temperature}C");
      },
      onError: (error) {
        log("Error while monitoring characteristic \n$error");
      },
      cancelOnError: true,
    );
  }

  double _convertToTemperature(Uint8List rawTemperatureBytes) {
    const double SCALE_LSB = 0.03125;
    int rawTemp = rawTemperatureBytes[3] << 8 | rawTemperatureBytes[2];
    return ((rawTemp) >> 2) * SCALE_LSB;
  }

  Future<void> disableBluetooth() async {
    await _runWithErrorHandling(() async {
      log("Disabling radio");
      await bleManager.disableRadio();
    });
  }

  Future<void> enableBluetooth() async {
    await _runWithErrorHandling(() async {
      log("Enabling radio");
      await bleManager.enableRadio();
    });
  }

  Future<void> fetchBluetoothState() async {
    await _runWithErrorHandling(() async {
      BluetoothState bluetoothState = await bleManager.bluetoothState();
      log("Radio state: $bluetoothState");
    });
  }

  Future<void> _runWithErrorHandling(TestedFunction testedFunction) async {
    try {
      await testedFunction();
    } on BleError catch (e) {
      logError("BleError caught: ${e.errorCode} ${e.reason}");
    } catch (e) {
      logError("${e.runtimeType}: $e");
    }
  }
}
