<p align="center">
  <img
    alt="FlutterBLE library logo"
    src="site/flutter-ble-lib-logo.png"
    height="300"
    style="margin-top: 20px; margin-bottom: 20px;"
  />
</p>

# FlutterBleLib

[![Frontside](https://img.shields.io/static/v1?label=Facilitated%20by&message=frontside.io&color=blue)](#facilitated-by-frontside)

A library for your all your Bluetooth Low Energy needs in Flutter. Internally utilises Polidea's 
[MultiPlatformBleAdapter](https://github.com/Polidea/MultiPlatformBleAdapter), 
which runs on [RxAndroidBle](https://github.com/Polidea/RxAndroidBle)
 and [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit).

## Configuration and installation
TBD

## Overview
The library is organised around a few base entities, which are:
* **BleManager**
* **Peripheral**
* **Service**
* **Characteristic**

You have to create an instance _BleManager_ and initialise underlying native resources. 
Using that instance you then obtain an instance of _Peripheral_,
 which can be used to run operations on the corresponding peripheral.
 
 All operations passing the Dart-native bridge are asynchronous,
  hence all operations in the plugin return either Future or Stream.

For more informations, see [REFERENCE](https://github.com/Polidea/FlutterBleLib/blob/readme/REFERENCE.md).

### Initialising
```dart
BleManager bleManager = BleManager();
bleManager.createClient(); //ready to go!
// your peripheral logic
bleManager.destroyClient(); //remember to release native resources when you're done!
```
Following snippets assume the library has been initialised.

### Handling Bluetooth adapter state
```dart
enum BluetoothState {
  UNKNOWN,
  UNSUPPORTED,
  UNAUTHORIZED,
  POWERED_ON,
  POWERED_OFF,
  RESETTING,
}


bleManager.enableRadio(); //ANDROID-ONLY turns on BT. NOTE: doesn't check permissions
bleManager.disableRadio() //ANDROID-ONLY turns off BT. NOTE: doesn't check permissions
BluetoothState currentState = await bleManager.bluetoothState();
bleManager.observeBluetoothState().listen((btState) {
  print(btState);
  //do your BT logic, open different screen, etc.
});
```
### Scanning for peripherals
```dart
bleManager.startPeripheralScan(
  uuids: [
    "F000AA00-0451-4000-B000-000000000000",
  ],
).listen((scanResult) {
  //Scan one peripheral and stop scanning
  print("Scanned Peripheral ${scanResult.peripheral.name}, RSSI ${scanResult.rssi}");
  bleManager.stopPeripheralScan();
});
```

The snippet above starts peripheral scan and stops it after receiving first result. 
It filters the scan results to those that advertise a service with specified UUID.

### Connecting to peripheral
First you must obtain a _ScanResult_ from _BleManager.startPeripheralScan()_.
```dart
Peripheral peripheral = scanResult.peripheral;
peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true)
  .listen((connectionState) {
    print("Peripheral ${scanResult.peripheral.identifier} connection state is $connectionState");
  });
await peripheral.connect();
bool connected = await peripheral.isConnected();
await peripheral.disconnectOrCancelConnection();
```

The snippet above starts observing the state of the connection to the peripheral,
 connects to it, checks if it's connected and then disconnects from it.

### Transactions

Methods that do not have counterpart with opposite effect and are asynchronous accept
 `String transactionId` as an optional argument, to allow the user to cancel such an operation.
 The Future returned to Dart will then finish with a _BleError(BleErrorCode.operationCancelled...)_,
 **but this will only discard the result of the operation, the operation itself will be executed either way**.
 
For example, if I decided that I no longer want to run discovery on the selected peripheral:
```dart
//assuming peripheral is connected
peripheral.discoverAllServicesAndCharacteristics(transactionId: "discovery"); 
//will return operation cancelled error after calling the below 
bleManager.cancelTransaction("discovery");
```

If no _transactionId_ has been specified, it is _null_. Each new operation with the same _transactionId_
will cause the previous to be cancelled with error, if it hasn't finished yet.

**NOTE: _null_ is a valid transactionId, which means every operation with default transactionId will cancel any ongoing operation with default _transactionId_.**

### Obtaining characteristics

To be able to operate on the peripheral, discovery of its services and characteristics must be run first.

```dart
//assuming peripheral is connected
await peripheral.discoverAllServicesAndCharacteristics();
List<Service> services = await peripheral.services(); //getting all services
List<Characteristic> characteristics1 = await peripheral.characteristics("F000AA00-0451-4000-B000-000000000000");
List<Characteristic> characteristics2 = await services.firstWhere(
  (service) => service.uuid == "F000AA00-0451-4000-B000-000000000000").characteristics();

//characteristics1 and characteristics2 have the same contents
```

Objects representing characteristics have a unique identifer, so they point to one specific characteristic,
 even if there are multiple service/characteristic uuid matches.
### Manipulating characteristics
Below are 3 methods of writing to a characteristic, which all result in the same effect given
 there's only one service with specified UUID and only one characteristic with specified UUID.
```dart
peripheral.writeCharacteristic(
  "F000AA00-0451-4000-B000-000000000000",
  "F000AA02-0451-4000-B000-000000000000",
  Uint8List.fromList([0]),
  false); //returns Characteristic to chain operations more easily

service.writeCharacteristic(
  "F000AA02-0451-4000-B000-000000000000",
  Uint8List.fromList([0]),
  false); //returns Characteristic to chain operations more easily

characteristic.write(Uint8List.fromList([0]), false); //returns void
```

Monitoring or reading a characteristic from _Peripheral_/_Service_ level 
 return _CharacteristicWithValue_ object, which is _Characteristic_ with additional `Uint8List value` property.
 
## Facilitated by Frontside 
[Frontside](https://github.com/thefrontside) provided architectural advice and financial support for this library on behalf of [Resideo](https://github.com/resideo). 

## Maintained by
This library is maintained by [Polidea](http://www.polidea.com)

[Learn more about Polidea's BLE services](https://www.polidea.com/services/ble).

#### Maintainers
TBD

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

## More from Polidea
Check out other Polidea's BLE libraries:
* [react-native-ble-plx](https://github.com/Polidea/react-native-ble-plx)
* [RxAndroidBle](https://github.com/Polidea/RxAndroidBle)
* [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit)
