# BLEmulator

Plugin for simulating Bluetooth Low Energy peripherals.

**Note:** Works only with [FlutterBleLib](https://github.com/Polidea/FlutterBleLib).

It imitates the behaviour of [MultiPlatformBleAdapter](https://github.com/Polidea/MultiPlatformBleAdapter) and lets you create simulated peripherals in Dart. 
Your Flutter code for handling BLE will not be aware that it doesn't run on the real implementation, since the simulation is plugged in beneath the native bridge of FlutterBleLib.
## Configuration and installation
TBD
## How to use

To start simulating a BLE peripheral:
1. obtain an instance of Blemulator
2. add a SimulatedPeripheral
3. call _blemulator.simulate()_
4. call FlutterBleLib's _bleManager.createClient()_

```dart
Blemulator blemulator = Blemulator();
blemulator.addSimulatedPeripheral(ExamplePeripheral());
blemulator.simulate();

BleManager bleManager = BleManager();
bleManager.createClient(); //this creates an instance of native BLE
```
### Defining simulated peripheral
The following peripheral is based on [Texas Instruments CC2541 SensorTag](http://www.ti.com/tool/CC2541DK-SENSOR).
To keep the example clearer, only IR temperature service is simulated.
```dart
class SensorTag extends SimulatedPeripheral {
  SensorTag(
      {String id = "4C:99:4C:34:DE:76",
      String name = "SensorTag",
      String localName = "SensorTag"})
      : super(
            name: name,
            id: id,
            advertisementInterval: Duration(milliseconds: 800),
            services: [
              SimulatedService(
                  uuid: "F000AA00-0451-4000-B000-000000000000",
                  isAdvertised: true,
                  characteristics: [
                    SimulatedCharacteristic(
                        uuid: "F000AA01-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([101, 254, 64, 12]),
                        convenienceName: "IR Temperature Data"),
                    SimulatedCharacteristic(
                        uuid: "F000AA02-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Config"),
                    SimulatedCharacteristic(
                        uuid: "F000AA03-0451-4000-B000-000000000000",
                        value: Uint8List.fromList([50]),
                        convenienceName: "IR Temperature Period"),
                  ],
                  convenienceName: "Temperature service")
            ]) {
    scanInfo.localName = localName;
  }

  @override
  Future<bool> onConnectRequest() async {
    await Future.delayed(Duration(milliseconds: 200));
    return super.onConnectRequest();
  }
}
```

This creates a peripheral that advertises every 800 milliseconds while peripheral scan is on,
 waits for 200 milliseconds after receiving connection request before agreeing to connect and has a single service 
 with three characteristics according to [SensorTag documentation](http://processors.wiki.ti.com/images/a/a8/BLE_SensorTag_GATT_Server.pdf).

The _convenienceName_ fields are optional and not used by the blemulator itself, but allow you to name created objects for better maintainability.

#### Changing advertisement data or scan info

For your convenience you can mark SimulatedService as advertised, but be aware that this doesn't validate the size of advertised services array inside advertisement data.

If you want to have more granular control over what is advertised, simply modify the _scanInfo_ property of the SimulatedPeripheral.
 The _scanInfo_ is broadcasted automatically while peripheral scan is on each _advertisementInterval_.
 
ScanInfo supports following data:
```dart
class ScanInfo {
  int rssi;
  bool isConnectable;
  int txPowerLevel;

  Uint8List manufacturerData;
  Map<String, Uint8List> serviceData;
  List<String> serviceUuids;

  String localName;
  List<String> solicitedServiceUuids;
  List<String> overflowUuids;
}
```
You can also provide it in the constructor of the SimulatedPeripheral.

#### Custom characteristic behaviour
Blemulator does most of the heavy lifting for you and takes care of the basic stuff, but there's always more complicated logic.
If you need to validate values or writing to one characteristic has to trigger a change in the behaviour of different characteristic,
 you may need to extend SimulatedService or SimulatedCharacteristic classes.
##### Limiting values supported by characteristic

Following is an example of a characteristic that accepts only 0 or 1.
```dart
class ExampleCharacteristic extends SimulatedCharacteristic {
  ExampleCharacteristic({@required String uuid, String convenienceName})
      : super(
            uuid: uuid,
            value: Uint8List.fromList([0]),
            convenienceName: convenienceName);

  @override
  Future<void> write(Uint8List value) {
    int valueAsInt = value.buffer.asByteData().getUint8(0);
    if (valueAsInt != 0 && valueAsInt != 1) {
      return Future.error(SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed, "Unsupported value"));
    } else {
      return super.write(value); //this propagates value through the blemulator,
      // allowing you to react to changes done to this characteristic
    }
  }
}
```


#### Publishing notifications
This time peripheral has additional logic. _IR Temperature Config_ characteristic turns the IR thermometer on (1) and off (0).
 Regardless of that the _IR Temperature Data_ emits data each (_IR Temperature Period_ value times 10) milliseconds (as per specification linked above) and that may be actual reading or zero.

```dart
class SensorTag extends SimulatedPeripheral {
  static const String _serviceUuid = "F000AA00-0451-4000-B000-000000000000";
  static const String _temperatureDataUuid =
      "F000AA01-0451-4000-B000-000000000000";
  static const String _temperatureConfigUuid =
      "F000AA02-0451-4000-B000-000000000000";
  static const String _temperaturePeriodUuid =
      "F000AA03-0451-4000-B000-000000000000";

  bool _readingTemperature;

  SensorTag(
      {String id = "4B:99:4C:34:DE:77",
      String name = "SensorTag",
      String localName = "SensorTag"})
      : super(
            name: name,
            id: id,
            advertisementInterval: Duration(milliseconds: 800),
            services: [
              SimulatedService(
                  uuid: _serviceUuid,
                  isAdvertised: true,
                  characteristics: [
                    SimulatedCharacteristic(
                      uuid: _temperatureDataUuid,
                      value: Uint8List.fromList([0, 0, 0, 0]),
                      convenienceName: "IR Temperature Data",
                      isWritableWithoutResponse: false,
                      isWritableWithResponse: false,
                    ),
                    SimulatedCharacteristic(
                        uuid: _temperatureConfigUuid,
                        value: Uint8List.fromList([0]),
                        convenienceName: "IR Temperature Config"),
                    SimulatedCharacteristic(
                        uuid: _temperaturePeriodUuid,
                        value: Uint8List.fromList([50]),
                        convenienceName: "IR Temperature Period"),
                  ],
                  convenienceName: "Temperature service"),
            ]) {
    scanInfo.localName = localName;

    getCharacteristicForService(_serviceUuid, _temperatureConfigUuid)
        .monitor()
        .listen((value) {
      int valueAsInt = value.buffer.asByteData().getUint8(0);
      _readingTemperature = valueAsInt == 1 ? true : false;
    });

    _emitTemperature();
  }

  void _emitTemperature() async {
    while (true) {
      Uint8List delayBytes = await getCharacteristicForService(
              _serviceUuid, _temperaturePeriodUuid)
          .read();
      int delay = delayBytes.buffer.asByteData().getUint8(0) * 10;
      await Future.delayed(Duration(milliseconds: delay));
      if (getCharacteristicForService(_serviceUuid, _temperatureConfigUuid)
          .isNotifying) {
        SimulatedCharacteristic temperatureDataCharacteristic =
            getCharacteristicForService(_serviceUuid, _temperatureDataUuid);
        if (_readingTemperature) {
          temperatureDataCharacteristic
              .write(Uint8List.fromList([101, 254, 64, Random().nextInt(255)]));
        } else {
          temperatureDataCharacteristic.write(Uint8List.fromList([0, 0, 0, 0]));
        }
      }
    }
  }

  @override
  Future<bool> onConnectRequest() async {
    await Future.delayed(Duration(milliseconds: 200));
    return super.onConnectRequest();
  }
}
```
The example above could be refactored to a custom SimulatedService with all the
 logic that handles cross-characteristic mechanisms and a simplified SimulatedPeripheral that takes an instance of the newly created class.

## Maintained by
This library is maintained by [Polidea](http://www.polidea.com)

[Learn more about Polidea's BLE services](https://www.polidea.com/services/ble).

### Maintainers

## License
Copyright 2019 Polidea Sp. z o.o

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.