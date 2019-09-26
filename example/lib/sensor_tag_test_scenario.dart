import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';

import 'sensor_tag_config.dart';
import 'util/pair.dart';

typedef Logger = Function(String);

class TestScenario {
  BleManager bleManager = BleManager.getInstance();
  bool deviceConnectionAttempted = false;
  StreamSubscription monitoringStreamSubscription;

  Future<void> runTestScenario(Logger log, Logger logError) async {
    log("CREATING CLIENT...");
    await bleManager.createClient(
        restoreStateIdentifier: "5",
        restoreStateAction: (devices) {
          log("RESTORED DEVICES: $devices");
        });

    log("CREATED CLIENT");
    log("STARTING SCAN...");
    log("Looking for Sensor Tag...");
    bleManager.startPeripheralScan().listen((scanResult) async {
      log("RECEIVED SCAN RESULT: "
          "\n name: ${scanResult.peripheral.name}"
          "\n identifier: ${scanResult.peripheral.identifier}"
          "\n rssi: ${scanResult.rssi}");

      if (scanResult.peripheral.name == "SensorTag" &&
          !deviceConnectionAttempted) {
        log("Sensor Tag found!");
        deviceConnectionAttempted = true;
        log("Stopping device scan...");
        await bleManager.stopDeviceScan();
        return _tryToConnect(scanResult.peripheral, log, logError);
      }
    }, onError: (error) {
      logError(error);
    });
  }

  Future<void> _tryToConnect(
      Peripheral peripheral, Logger log, Logger logError) async {
    log("OBSERVING connection state \nfor ${peripheral.name},"
        " ${peripheral.identifier}...");

    peripheral
        .observeConnectionState(emitCurrentValue: true)
        .listen((connectionState) {
      log("Current connection state is: \n $connectionState");
      if (connectionState == PeripheralConnectionState.disconnected) {
        log("${peripheral.name} has DISCONNECTED");
      }
    });
    log("CONNECTING to ${peripheral.name}, ${peripheral.identifier}...");
    await peripheral.connect();
    log("CONNECTED to ${peripheral.name}, ${peripheral.identifier}!");
    deviceConnectionAttempted = false;

    monitoringStreamSubscription?.cancel();
    monitoringStreamSubscription = peripheral
        .monitorCharacteristic(SensorTagTemperatureUuids.temperatureService,
            SensorTagTemperatureUuids.temperatureConfigCharacteristic)
        .listen(
      (characteristic) {
        log("Characteristic ${characteristic.uuid} changed. New value: ${characteristic.value}");
      },
      onError: (error) {
        log("Error when trying to modify characteristic value. $error");
      },
    );

    peripheral
        .discoverAllServicesAndCharacteristics()
        .then((_) => peripheral.services())
        .then((services) {
          log("PRINTING SERVICES for ${peripheral.name}");
          services.forEach((service) => log("Found service ${service.uuid}"));
          return services.first;
        })
        .then((service) async {
          log("PRINTING CHARACTERISTICS FOR SERVICE \n${service.uuid}");
          List<Characteristic> characteristics =
              await service.characteristics();
          characteristics.forEach((characteristic) {
            log("${characteristic.uuid}");
          });

          log("PRINTING CHARACTERISTICS FROM \nPERIPHERAL for the same service");
          return peripheral.characteristics(service.uuid);
        })
        .then((characteristics) => characteristics.forEach((characteristic) =>
            log("Found characteristic \n ${characteristic.uuid}")))
        .then((_) => log("Test read/write characteristic on device"))
        .then((_) {
          log("Turn off temperature update");
          return peripheral.writeCharacteristic(
              SensorTagTemperatureUuids.temperatureService,
              SensorTagTemperatureUuids.temperatureConfigCharacteristic,
              Uint8List.fromList([0]),
              false);
        })
        .then((_) {
          return peripheral.readCharacteristic(
              SensorTagTemperatureUuids.temperatureService,
              SensorTagTemperatureUuids.temperatureDataCharacteristic);
        })
        .then((data) {
          log("Temperature value ${data.value}");
        })
        .then((_) {
          log("Turn on temperature update");
          return peripheral.writeCharacteristic(
              SensorTagTemperatureUuids.temperatureService,
              SensorTagTemperatureUuids.temperatureConfigCharacteristic,
              Uint8List.fromList([1]),
              false);
        })
        .then((_) => Future.delayed(Duration(seconds: 1)))
        .then((_) {
          return peripheral.readCharacteristic(
              SensorTagTemperatureUuids.temperatureService,
              SensorTagTemperatureUuids.temperatureDataCharacteristic);
        })
        .then((data) {
          log("Temperature value ${data.value}");
        })
        .then((_) => log("Test read/write characteristic on service"))
        .then((_) async {
          log("Turn off temperature update");
          Service service = await peripheral.services().then((services) =>
              services.firstWhere((service) =>
                  service.uuid ==
                  SensorTagTemperatureUuids.temperatureService.toLowerCase()));
          await service.writeCharacteristic(
            SensorTagTemperatureUuids.temperatureConfigCharacteristic,
            Uint8List.fromList([0]),
            false,
          );
          return service;
        })
        .then((service) =>
            Future.delayed(Duration(seconds: 1)).then((_) => service))
        .then((service) async {
          CharacteristicWithValue dataCharacteristic =
              await service.readCharacteristic(
                  SensorTagTemperatureUuids.temperatureDataCharacteristic);
          return Pair(service, dataCharacteristic);
        })
        .then((serviceAndCharacteristic) {
          log("Temperature value ${serviceAndCharacteristic.second.value}");
          return serviceAndCharacteristic.first;
        })
        .then((service) async {
          log("Turn on temperature update");
          Characteristic configCharacteristic =
              await service.writeCharacteristic(
                  SensorTagTemperatureUuids.temperatureConfigCharacteristic,
                  Uint8List.fromList([1]),
                  false);
          return Pair(service, configCharacteristic);
        })
        .then((serviceAndConfigCharacteristic) =>
            Future.delayed(Duration(seconds: 1))
                .then((_) => serviceAndConfigCharacteristic))
        .then((serviceAndConfigCharacteristic) async {
          CharacteristicWithValue dataCharacteristic =
              await serviceAndConfigCharacteristic.first.readCharacteristic(
                  SensorTagTemperatureUuids.temperatureDataCharacteristic);
          return Pair(
              serviceAndConfigCharacteristic.second, dataCharacteristic);
        })
        .then((configAndDataCharacteristics) {
          log("Temperature value ${configAndDataCharacteristics.second.value}");
          log("Test read/write characteristic on characteristic");
          return configAndDataCharacteristics.first;
        })
        .then((characteristic) =>
            Future.delayed(Duration(seconds: 1)).then((_) => characteristic))
        .then((characteristic) async {
          log("Turn off temperature update");
          await characteristic.write(Uint8List.fromList([0]), false);
          return characteristic;
        })
        .then((characteristic) =>
            Future.delayed(Duration(seconds: 1)).then((_) => characteristic))
        .then((characteristic) async {
          Uint8List value = await characteristic.read();
          return Pair(characteristic, value);
        })
        .then((characteristicAndValue) {
          log("Temperature config value ${characteristicAndValue.second}");
          return characteristicAndValue.first;
        })
        .then((characteristic) async {
          log("Turn on temperature update");
          await characteristic.write(Uint8List.fromList([1]), false);
          return characteristic;
        })
        .then((characteristic) =>
            Future.delayed(Duration(seconds: 1)).then((_) => characteristic))
        .then((characteristic) => characteristic.read())
        .then((value) {
          log("Temperature config value $value");
        })
        .then((_) {
          log("WAITING 10 SECOND BEFORE DISCONNECTING");
          return Future.delayed(Duration(seconds: 10));
        })
        .then((_) {
          log("DISCONNECTING...");
          return peripheral.disconnectOrCancelConnection();
        })
        .then((_) {
          log("Disconnected!");
          log("WAITING 10 SECOND BEFORE DESTROYING CLIENT");
          return Future.delayed(Duration(seconds: 10));
        })
        .then((_) {
          log("DESTROYING client...");
          return bleManager.destroyClient();
        })
        .then((_) => log("\BleClient destroyed after a delay"));
  }
}
