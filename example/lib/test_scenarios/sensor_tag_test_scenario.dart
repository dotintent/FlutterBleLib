part of test_scenarios;

class SensorTagTestScenario {
  final Peripheral peripheral;
  final Logger log;
  final Logger logError;
  final BleManager bleManager;

  SensorTagTestScenario(this.bleManager, this.peripheral, this.log, this.logError);

  Future<void> runTestScenario() async {
    _connect()
        .then((_) => _discovery())
        .then((_) => _testRequestingMtu())
        .then((_) => _testReadingRssi())
        .then((_) => _readWriteCharacteristicForPeripheral())
        .then((_) => _readWriteCharacteristicForService())
        .then((_) => _readWriteCharacteristic())
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

  Future<void> _readWriteCharacteristicForPeripheral() async {
    log("Test read/write characteristic on device");
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
    log("Reada temperature value ${readValue.value}");

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
    log("Read temperature value ${readValue.value}");

    return peripheral;
  }

  Future<void> _readWriteCharacteristicForService() async {
    log("Test read/write characteristic on service");
    log("Fetching service");

    Service service = await peripheral.services().then((services) =>
        services.firstWhere((service) =>
            service.uuid ==
            SensorTagTemperatureUuids.temperatureService.toLowerCase()));

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
    log("Read temperature value ${dataCharacteristic.value}");

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
    log("Read temperature value ${dataCharacteristic.value}");
  }

  Future<void> _readWriteCharacteristic() async {
    log("Test read/write characteristic on characteristic");

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

    log("Turning off temperature update");
    await characteristic.write(Uint8List.fromList([0]), false);
    log("Turned off temperature update");

    log("Reading characteristic value");
    Uint8List value = await characteristic.read();
    log("Read temperature config value $value");

    log("Turning on temperature update");
    await characteristic.write(Uint8List.fromList([1]), false);
    log("Turning off temperature update");

    log("Reading characteristic value");
    value = await characteristic.read();
    log("Read temperature config value $value");
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
    List<Peripheral> peripherals = await bleManager.connectedDevices([peripheral.identifier]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
  }

  Future<void> _fetchKnownDevice() async {
    log("Fetch known devices");
    List<Peripheral> peripherals = await bleManager.knownDevices([]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
  }
}
