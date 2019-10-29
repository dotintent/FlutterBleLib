part of test_scenarios;

class SensorTagTestScenario {
  PeripheralTestOperations _peripheralTestOperations;

  SensorTagTestScenario(BleManager bleManager,
      Peripheral peripheral,
      Logger log,
      Logger logError) {
    _peripheralTestOperations = PeripheralTestOperations(bleManager, peripheral, log, logError);
  }

  Future<void> runTestScenario() async {
    _peripheralTestOperations.connect()
        .then((_) => _peripheralTestOperations.cancelTransaction())
        .then((_) => _peripheralTestOperations.discovery())
//        .then((_) => _peripheralTestOperations.testRequestingMtu())
        .then((_) => _peripheralTestOperations.testReadingRssi())
        .then((_) => _peripheralTestOperations.readWriteMonitorCharacteristicForPeripheral())
        .then((_) => _peripheralTestOperations.readWriteMonitorCharacteristicForService())
        .then((_) => _peripheralTestOperations.readWriteMonitorCharacteristic())
        .then((_) => _peripheralTestOperations.fetchConnectedDevice())
        .then((_) => _peripheralTestOperations.fetchKnownDevice())
        .then((_) => _peripheralTestOperations.disconnect())
        .catchError((error) => _peripheralTestOperations.logError(error));
  }


}
