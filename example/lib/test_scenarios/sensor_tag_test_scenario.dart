part of test_scenarios;

class SensorTagTestScenario extends TestScenario {
  final Peripheral _peripheral;

  SensorTagTestScenario(this._peripheral);

  @override
  Future<void> runTestScenario(Logger log, Logger logError) async {
    _connect(log, logError, _peripheral)
        .then((peripheral) => _discovery(log, logError, peripheral))
        .then((peripheral) => _mtu(log, logError, peripheral))
        .then((peripheral) => _rssi(log, logError, peripheral))
        .then((peripheral) =>
            _readWriteCharacteristicForPeripheral(log, logError, peripheral))
        .then((peripheral) =>
            _readWriteCharacteristicForService(log, logError, peripheral))
        .then(
            (peripheral) => _readWriteCharacteristic(log, logError, peripheral))
        .then((peripheral) => _disconnect(log, logError, peripheral));
  }

  Future<Peripheral> _connect(
      Logger log, Logger logError, Peripheral peripheral) async {
    log("Connecting to ${_peripheral.name}");
    await _peripheral.connect();
    log("Connected!");
    return peripheral;
  }

  Future<Peripheral> _discovery(
      Logger log, Logger logError, Peripheral peripheral) async {
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
        await _peripheral.characteristics(service.uuid);
    characteristicFromPeripheral.forEach((characteristic) =>
        log("Found characteristic \n ${characteristic.uuid}"));
    return peripheral;
  }

  Future<Peripheral> _rssi(
      Logger log, Logger logError, Peripheral peripheral) async {
    int rssi = await peripheral.rssi();
    log("rssi $rssi");
    return peripheral;
  }

  Future<Peripheral> _mtu(
      Logger log, Logger logError, Peripheral peripheral) async {
    int requestedMtu = 79;
    log("Requesting MTU = $requestedMtu");
    int negotiatedMtu = await peripheral.requestMtu(requestedMtu);
    log("negotiated MTU $negotiatedMtu");
    return peripheral;
  }

  Future<Peripheral> _readWriteCharacteristicForPeripheral(
      Logger log, Logger logError, Peripheral peripheral) async {
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

  Future<Peripheral> _readWriteCharacteristicForService(
      Logger log, Logger logError, Peripheral peripheral) async {
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

    return peripheral;
  }

  Future<Peripheral> _readWriteCharacteristic(
      Logger log, Logger logError, Peripheral peripheral) async {
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
            SensorTagTemperatureUuids.temperatureConfigCharacteristic.toLowerCase()));

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

    return peripheral;
  }

  Future<void> _disconnect(
      Logger log, Logger logError, Peripheral peripheral) async {
    log("WAITING 10 SECOND BEFORE DISCONNECTING");
    await Future.delayed(Duration(seconds: 10));
    log("DISCONNECTING...");
    await peripheral.disconnectOrCancelConnection();
    log("Disconnected!");
  }
}
