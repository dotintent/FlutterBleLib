part of test_scenarios;

class PeripheralTestOperations {
  final Peripheral peripheral;
  final Logger log;
  final Logger logError;
  StreamSubscription monitoringStreamSubscription;
  final BleManager bleManager;

  PeripheralTestOperations(
      this.bleManager, this.peripheral, this.log, this.logError);

  Future<void> connect() async {
    try {
      log("Connecting to ${peripheral.name}");
      await peripheral.connect();
      log("Connected!");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> cancelTransaction() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> discovery() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> testReadingRssi() async {
    try {
      int rssi = await peripheral.rssi();
      log("rssi $rssi");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> testRequestingMtu() async {
    try {
      int requestedMtu = 79;
      log("Requesting MTU = $requestedMtu");
      int negotiatedMtu = await peripheral.requestMtu(requestedMtu);
      log("negotiated MTU $negotiatedMtu");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readCharacteristicForPeripheral() async {
    try {
      log("Reading temperature config");
      CharacteristicWithValue readValue = await peripheral.readCharacteristic(
          SensorTagTemperatureUuids.temperatureService,
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Temperature config value: \n${_convertToTemperature(readValue.value)}C");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readCharacteristicForService() async {
    try {
      log("Reading temperature config");
      Service service = await peripheral.services().then((services) =>
          services.firstWhere((service) =>
              service.uuid ==
              SensorTagTemperatureUuids.temperatureService.toLowerCase()));
      CharacteristicWithValue readValue = await service.readCharacteristic(
          SensorTagTemperatureUuids.temperatureDataCharacteristic);
      log("Temperature config value: \n${_convertToTemperature(readValue.value)}C");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readCharacteristic() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> writeCharacteristicForPeripheral() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> writeCharacteristicForService() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> writeCharacteristic() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> monitorCharacteristicForPeripheral() async {
    try {
      log("Start monitoring temperature update");
      _startMonitoringTemperature(
          peripheral
              .monitorCharacteristic(
                  SensorTagTemperatureUuids.temperatureService,
                  SensorTagTemperatureUuids.temperatureDataCharacteristic,
                  transactionId: "monitor")
              .map((characteristic) => characteristic.value),
          log);
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> monitorCharacteristicForService() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> monitorCharacteristic() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readWriteMonitorCharacteristicForPeripheral() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readWriteMonitorCharacteristicForService() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> readWriteMonitorCharacteristic() async {
    try {
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
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> disconnect() async {
    try {
      log("WAITING 10 SECOND BEFORE DISCONNECTING");
      await Future.delayed(Duration(seconds: 10));
      log("DISCONNECTING...");
      await peripheral.disconnectOrCancelConnection();
      log("Disconnected!");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> fetchConnectedDevice() async {
    try {
      log("Fetch connected devices with no service specified");
      List<Peripheral> peripherals = await bleManager.connectedDevices([]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
      log("Fetch connected devices with temperature service");
      peripherals = await bleManager
          .connectedDevices([SensorTagTemperatureUuids.temperatureService]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
  }

  Future<void> fetchKnownDevice() async {
    try {
      log("Fetch known devices with no IDs specified");
      List<Peripheral> peripherals = await bleManager.knownDevices([]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
      log("Fetch known devices with one known device's ID specified");
      peripherals = await bleManager.knownDevices([peripheral.identifier]);
      peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
      log("Device fetched");
    } on BleError catch (e) {
      logError("ERROR CAUGHT: ${e.errorCode} ${e.reason}");
    }
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
    log("Disabling radio");
    await bleManager.disableRadio();
  }

  Future<void> enableBluetooth() async {
    log("Enabling radio");
    await bleManager.enableRadio();
  }

  Future<void> fetchBluetoothState() async {
    BluetoothState bluetoothState = await bleManager.bluetoothState();
    log("Radio state: $bluetoothState");
  }
}
