part of test_scenarios;

class SensorTagTestScenario {
  final Peripheral peripheral;
  final Logger log;
  final Logger logError;
  StreamSubscription monitoringStreamSubscription;
  final BleManager bleManager;

  SensorTagTestScenario(
      this.bleManager, this.peripheral, this.log, this.logError);

  Future<void> runTestScenario() async {
    _connect()
        .then((_) => _cancelTransaction())
        .then((_) => _discovery())
        .then((_) => _testRequestingMtu())
        .then((_) => _testReadingRssi())
        .then((_) => _readWriteMonitorCharacteristicForPeripheral())
        .then((_) => _readWriteMonitorCharacteristicForService())
        .then((_) => _readWriteMonitorCharacteristic())
        .then((_) => _fetchConnectedDevice())
        .then((_) => _fetchKnownDevice())
        .then((_) => _disconnect());
  }

  Future<void> _connect() async {
    log("Connecting to ${peripheral.name}");
    await peripheral.connect();
    log("Connected!");
    return peripheral;
  }

  Future<void> _cancelTransaction() async {
    peripheral
        .discoverAllServicesAndCharacteristics(transactionId: "test")
        .catchError((error) => logError(error));

    bleManager.cancelTransaction("test");
  }

  Future<void> _discovery() async {
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

  Future<void> _testReadingRssi() async {
    int rssi = await peripheral.rssi();
    log("rssi $rssi");
    return peripheral;
  }

  Future<void> _testRequestingMtu() async {
    int requestedMtu = 79;
    log("Requesting MTU = $requestedMtu");
    int negotiatedMtu = await peripheral.requestMtu(requestedMtu);
    log("negotiated MTU $negotiatedMtu");
    return peripheral;
  }

  Future<void> _readWriteMonitorCharacteristicForPeripheral() async {
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

  Future<void> _readWriteMonitorCharacteristicForService() async {
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

  Future<void> _readWriteMonitorCharacteristic() async {
    log("Test read/write/monitor characteristic on characteristic");

    log("Fetching service");

    Service service = await peripheral.services().then((services) =>
        services.firstWhere((service) =>
            service.uuid ==
            SensorTagTemperatureUuids.temperatureService.toLowerCase()));

    log("Fetching characteristic");
    Characteristic characteristic = await service.characteristics().then(
        (characteristics) => characteristics.firstWhere((characteristic) =>
            characteristic.uuid ==
            SensorTagTemperatureUuids.temperatureConfigCharacteristic
                .toLowerCase()));

    log("Start monitoring temperature");
    _startMonitoringTemperature(
      characteristic.monitor(transactionId: "1"),
      log,
    );

    log("Turning off temperature update");
    await characteristic.write(Uint8List.fromList([0]), false);
    log("Turned off temperature update");

    log("Reading characteristic value");
    Uint8List value = await characteristic.read();
    log("Read temperature config value ${_convertToTemperature(value)}C");

    log("Turning on temperature update");
    await characteristic.write(Uint8List.fromList([1]), false);
    log("Turning off temperature update");

    log("Reading characteristic value");
    value = await characteristic.read();
    log("Read temperature config value ${_convertToTemperature(value)}C");

    return peripheral;
  }

  Future<void> _disconnect() async {
    log("WAITING 10 SECOND BEFORE DISCONNECTING");
    await Future.delayed(Duration(seconds: 10));
    log("DISCONNECTING...");
    await peripheral.disconnectOrCancelConnection();
    log("Disconnected!");
  }

  Future<void> _fetchConnectedDevice() async {
    log("Fetch connected devices");
    List<Peripheral> peripherals =
        await bleManager.connectedDevices([peripheral.identifier]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
  }

  Future<void> _fetchKnownDevice() async {
    log("Fetch known devices");
    List<Peripheral> peripherals = await bleManager.knownDevices([]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
  }

  void _startMonitoringTemperature(
      Stream<Uint8List> characteristicUpdates, Function log) {
    log("START TEMPERATURE MONITORING");
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
