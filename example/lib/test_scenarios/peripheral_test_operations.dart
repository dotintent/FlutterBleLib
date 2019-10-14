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
    log("Connecting to ${peripheral.name}");
    await peripheral.connect();
    log("Connected!");
  }

  Future<void> cancelTransaction() async {
    log("Starting operation to cancel...");
    peripheral
        .discoverAllServicesAndCharacteristics(transactionId: "test")
        .catchError((error) {
      BleError bleError = error as BleError;
      return logError("Cancelled operation caught an error: "
          "error code ${bleError.errorCode},"
          " reason: ${bleError.reason}");
    });
    log("Operation to cancel started: discover all"
        " services and characteristics");

    log("Cancelling operation...");
    await bleManager.cancelTransaction("test");
    log("Operation cancelled!");
  }

  Future<void> discovery() async {
    await peripheral.discoverAllServicesAndCharacteristics();
    List<Service> services = await peripheral.services();
    log("PRINTING SERVICES for ${peripheral.name}");
    services.forEach((service) => log("Found service ${service.uuid}"));
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
    return peripheral;
  }

  Future<void> testReadingRssi() async {
    int rssi = await peripheral.rssi();
    log("rssi $rssi");
  }

  Future<void> testRequestingMtu() async {
    int requestedMtu = 79;
    log("Requesting MTU = $requestedMtu");
    int negotiatedMtu = await peripheral.requestMtu(requestedMtu);
    log("negotiated MTU $negotiatedMtu");
  }

  Future<void> readCharacteristicForPeripheral() async {
    log("Reading temperature");
    CharacteristicWithValue readValue = await peripheral.readCharacteristic(
        SensorTagTemperatureUuids.temperatureService,
        SensorTagTemperatureUuids.temperatureDataCharacteristic);
    log("Read temperature value ${_convertToTemperature(readValue.value)}C");
  }

  Future<void> writeCharacteristicForPeripheral() async {
    log("Turning on temperature update via peripheral");
    await peripheral.writeCharacteristic(
        SensorTagTemperatureUuids.temperatureService,
        SensorTagTemperatureUuids.temperatureConfigCharacteristic,
        Uint8List.fromList([1]),
        false);

    log("Turned on temperature update");
  }

  Future<void> readWriteMonitorCharacteristicForPeripheral() async {
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

    return peripheral;
  }

  Future<void> readWriteMonitorCharacteristicForService() async {
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

    return peripheral;
  }

  Future<void> readWriteMonitorCharacteristic() async {
    log("Test read/write/monitor characteristic on characteristic");

    log("Fetching service");
    try {
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

      log("Reading characteristic value");
      Uint8List value = await configCharacteristic.read();
      log("Read temperature config value $value");

      log("Turning on temperature update");
      await configCharacteristic.write(Uint8List.fromList([1]), false);
      log("Turned on temperature update");

      log("Reading characteristic value");
      value = await configCharacteristic.read();
      log("Read temperature config value $value");
    } catch (e) {
      logError(e.reason);
    }

    return peripheral;
  }

  Future<void> disconnect() async {
    log("WAITING 10 SECOND BEFORE DISCONNECTING");
    await Future.delayed(Duration(seconds: 10));
    log("DISCONNECTING...");
    await peripheral.disconnectOrCancelConnection();
    log("Disconnected!");
  }

  Future<void> fetchConnectedDevice() async {
    log("Fetch connected devices with temperature service");
    List<Peripheral> peripherals = await bleManager
        .connectedDevices([SensorTagTemperatureUuids.temperatureService]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
    log("Device fetched");
  }

  Future<void> fetchKnownDevice() async {
    log("Fetch known devices");
    List<Peripheral> peripherals =
        await bleManager.knownDevices([peripheral.identifier]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
  }

  void _startMonitoringTemperature(
      Stream<Uint8List> characteristicUpdates, Function log) {
    monitoringStreamSubscription?.cancel();
    monitoringStreamSubscription = characteristicUpdates
        .map(_convertToTemperature)
        .where((temperature) => temperature != 0)
        .take(1)
        .listen(
      (temperature) {
        log("Temperature updated: ${temperature}C");
      },
      onError: (error) {
        log("Error when trying to modify characteristic value. $error");
      },
    );
  }

  double _convertToTemperature(Uint8List rawTemperatureBytes) {
    const double SCALE_LSB = 0.03125;
    int rawTemp = rawTemperatureBytes[3] << 8 | rawTemperatureBytes[2];
    return ((rawTemp) >> 2) * SCALE_LSB;
  }
}
