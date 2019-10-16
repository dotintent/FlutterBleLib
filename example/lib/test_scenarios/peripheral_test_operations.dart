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
    log("Reading temperature config");
    CharacteristicWithValueWithTransactionId readValue = await peripheral.readCharacteristic(
        SensorTagTemperatureUuids.temperatureService,
        SensorTagTemperatureUuids.temperatureConfigCharacteristic);
    log("Temperature config value: ${readValue.value}");
  }

  Future<void> readCharacteristicForService() async {
    log("Reading temperature config");
    Service service = await peripheral.services().then((services) =>
        services.firstWhere((service) =>
            service.uuid ==
            SensorTagTemperatureUuids.temperatureService.toLowerCase()));
    CharacteristicWithValueWithTransactionId readValue = await service.readCharacteristic(
        SensorTagTemperatureUuids.temperatureConfigCharacteristic);
    log("Temperature config value: ${readValue.value}");
  }

  Future<void> readCharacteristic() async {
    log("Reading temperature config");
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

    Uint8List readValue = await characteristic.read();
    log("Temperature config value: $readValue");
  }

  Future<void> writeCharacteristicForPeripheral() async {
    log("Turning on temperature update via peripheral");
    int valueToSave = Random().nextInt(2);
    await peripheral.writeCharacteristic(
        SensorTagTemperatureUuids.temperatureService,
        SensorTagTemperatureUuids.temperatureConfigCharacteristic,
        Uint8List.fromList([valueToSave]),
        false);

    log("Written \"$valueToSave\" to temperature config");
  }

  Future<void> writeCharacteristicForService() async {
    log("Turning on temperature update via service");
    int valueToSave = Random().nextInt(2);
    Service service = await peripheral.services().then((services) =>
        services.firstWhere((service) =>
            service.uuid ==
            SensorTagTemperatureUuids.temperatureService.toLowerCase()));

    await service.writeCharacteristic(
        SensorTagTemperatureUuids.temperatureConfigCharacteristic,
        Uint8List.fromList([valueToSave]),
        false);

    log("Written \"$valueToSave\" to temperature config");
  }

  Future<void> writeCharacteristic() async {
    log("Turning on temperature update via characteristic");
    int valueToSave = Random().nextInt(2);

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
    await characteristic.write(Uint8List.fromList([valueToSave]), false);
    log("Written \"$valueToSave\" to temperature config");
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
    CharacteristicWithValueWithTransactionId readValue = await peripheral.readCharacteristic(
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

  static int monitorCounter = 0;

  Future<void> monitorCharacteristicForPeripheral() async {
    log("Reading temperature");
    int id = monitorCounter;
    Stream<CharacteristicWithValueWithTransactionId> characteristicStream = await peripheral.monitorCharacteristic(
        SensorTagTemperatureUuids.temperatureService,
        SensorTagTemperatureUuids.temperatureDataCharacteristic,
        transactionId: "$id");
    characteristicStream.listen((characteristicValue) {
      log("Read temperature [$id] value ${_convertToTemperature(characteristicValue.value)}C");
    });
    ++monitorCounter;
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
    CharacteristicWithValueWithTransactionId dataCharacteristic =
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
    log("Fetch connected devices with no service specified");
    List<Peripheral> peripherals = await bleManager
        .connectedDevices([]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
    log("Device fetched");
    log("Fetch connected devices with temperature service");
    peripherals = await bleManager
        .connectedDevices([SensorTagTemperatureUuids.temperatureService]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
    log("Device fetched");
  }

  Future<void> fetchKnownDevice() async {
    log("Fetch known devices with no IDs specified");
    List<Peripheral> peripherals =
      await bleManager.knownDevices([]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
    log("Device fetched");
    log("Fetch known devices with one known device's ID specified");
    peripherals =  await bleManager.knownDevices([peripheral.identifier]);
    peripherals.forEach((peripheral) => log("\t${peripheral.toString()}"));
    log("Device fetched");
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

  Future<void> disableBluetooth() async {
    log("Disabling radio");
    await bleManager.disableRadio();
  }

  Future<void> enableBluetooth() async {
    log("Enabling radio");
    await bleManager.enableRadio();
  }

  Future<void> fetchBluetoothState() async {
    BluetoothState bluetoothState =await bleManager.bluetoothState();
    log("Radio state: $bluetoothState");
  }
}