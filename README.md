<p align="center">
  <img
    alt="FlutterBLE library logo"
    src="site/flutter-ble-lib-logo.png"
    height="300"
    style="margin-top: 20px; margin-bottom: 20px;"
  />
</p>

# FlutterBleLib
A library for your all your Bluetooth Low Energy needs in Flutter. Internally utilises Polidea's [MultiPlatformBleAdapter](https://github.com/Polidea/MultiPlatformBleAdapter).

### More from Polidea
Check out other Polidea's BLE libraries:
* [react-native-ble-plx](https://github.com/Polidea/react-native-ble-plx)
* [RxAndroidBle](https://github.com/Polidea/RxAndroidBle)
* [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit)

## Configuration and installation
TBD

## How to use
The library is organised around a few base entitites, which are:
* **BleManager**
* **Peripheral**
* **Service**
* **Characteristic**

The basic idea is to create an instance of **BleManager**, use it to create/release native clients of the underlying libraries, scan for peripherals and then operate on **Peripheral**.

### BleManager
This entity serves as the library's entry point. It doesn't track any state, so it is safe to create as many of those as you wish.

#### Initialization
```dart
  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  });
```
Creates native adapters for handling BLE. *This method has to be called before you can begin using the library.*
Both parameters are iOS-specific and handle restoration of already bonded devices, eg. after a crash.

Method will return error if an instance of native BleAdapter has already beeen created.
```dart
  Future<void> destroyClient();
```
Releases native resources. Should be called once there's no further need for BLE capabilities.
#### Scanning for peripherals
```dart
  Stream<ScanResult> startPeripheralScan({
    int scanMode,
    int callbackType,
    List<String> uuids,
    bool allowDuplicates,
  });
```
Returns a stream of objects containg advertisemnt data of the peripheral and the peripheral itself.
`scanMode` and `callbackType` are Android-specific. [More information in Android documentation](https://developer.android.com/reference/android/bluetooth/le/ScanSettings)
`allowDuplicates` is iOS-specific. [More information in iOS documentation](https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerscanoptionallowduplicateskey)
`uuids` is used to filter peripherals to only return those containing services with specified UUIDs.

```dart
  Future<void> stopDeviceScan();
```
Ends peripheral scan.
#### Managing log level
```dart
  Future<void> setLogLevel(LogLevel logLevel);
```
Sets log level of underlying native libraries. Possible values are:
* `none`
* `verbose`
* `debug`
* `info`
* `warning`
* `error`

```dart
  Future<LogLevel> logLevel();
```
Returns current log level of underlying native libraries.
#### Managing radio state
```dart
  Future<void> enableRadio({String transactionId});
```
Turns on system's Bluetooth Adapter.
Android-only feature. This operation will fail immediately on iOS.

```dart
  Future<void> disableRadio({String transactionId});
```
Turns off system's Bluetooth adapter.
Android-only feature. This operation will fail immediately on iOS.

```dart
  Future<BluetoothState> bluetoothState();
```
Return the current state of system's Bluetooth adapter.

```dart
  Stream<BluetoothState> observeBluetoothState({bool emitCurrentValue = true});
```
Returns a stream of system's Bluetooth adapter state changes. By default emits current value first; behaviour can be overridden by passing `false` to the optional argument.
#### Listing known devices
```dart
  Future<List<Peripheral>> knownDevices(List<String> peripheralIdentifiers);
```
Return a list of Peripherals that have been scanned and match any of the supplied identifiers. Returns empty list if an empty list is passed.
```dart
  Future<List<Peripheral>> connectedDevices(List<String> serviceUUIDs);
```
Returns a list of connecterd Peripherals that have at least one service with UUID matching any of the supplied UUIDs. Returns empty list if an empty list is passed.
#### Cancelling asynchronous operations
```dart
  Future<void> cancelTransaction(String transactionId);
```
Some of the asynchronous operations done by the library do not have a complementary `stop...()` function, but accept an optional parameter `transactionId`, eg. reading from characteristic. This function allows the user to break the execution of such operation, which will immediately return with BleError and errorCode `operationCancelled`.

**IMPORTANT**
The cancelled operation will still be completed (perhaps with error), but the user will not be notified about its result.
### Peripheral
Object representing a peripheral. Allows for managing connection, discovery and serves as a shortcut to characteristic operations, if the user knows the UUIDs of both service and characteristic.
#### Connection
```dart
  Future<void> connect(
          {bool isAutoConnect = false,
          int requestMtu,
          bool refreshGatt = false,
          Duration timeout});
```
Attemps to connect to the peripheral.
`requestMtu` defaults to 23.
`refreshGatt` forces GATT to refresh its cache; Android-specific.
If connection has not been established by `timeout`, the operation fails. `timeout` defaults to 30 seconds.
```dart
  Stream<PeripheralConnectionState> observeConnectionState(
          {bool emitCurrentValue = false,
          bool completeOnDisconnect = false});
```
Return a stream containing changes to the connection state. By default doesn't emit current state, nor terminates the stream after disconnecting.
**Note:** due ambiguities concerning `disconnecting` state, current implementation never emits `disconnecting`, only `connecting`, `connected`, `disconnected`.

```dart
  Future<bool> isConnected();
```
Returns true if the peripheral is currently connected.

```dart
  Future<void> disconnectOrCancelConnection();
```
Terminates connection or any attempt to connect.
#### Obtaining services and characteristics
```dart
  Future<void> discoverAllServicesAndCharacteristics({String transactionId}) =>
      _manager.discoverAllServicesAndCharacteristics(this, transactionId);
```
Runs the discovery process, caching all discovered services and characteristics in the native parts.
**Must be run before `services()` or `characteristics()`**
Operation is cancellable, meaning the operation's result in Dart can be discarded.
```dart
  Future<List<Service>> services() => _manager.services(this);
```
Returns list of all discovered services for the peripheral.
Fails if discovery has not been done.

```dart
  Future<List<Characteristic>> characteristics(String servicedUuid) =>
      _manager.characteristics(this, servicedUuid);
```
Returns list of all discovered characteristics for the specified service of the peripheral.
Fails if discovery has not been done.
#### RSSI and MTU
```dart
  Future<int> rssi({String transactionId}) {
    return _manager.rssi(this, transactionId);
  }
```
Reads current RSSI if the device is connected.
```dart
  Future<int> requestMtu(int mtu, {String transactionId}) {
    return _manager.requestMtu(this, mtu, transactionId);
  }
```
Request peripheral to set a different MTU. Operation is cancellable, meaning the operation's result in Dart can be discarded.
Return the MTU set by peripheral after request.
#### Characteristic convenience methods
Following operations will be discussed in details **Characteristic** section.
`CharacteristicWithValue` object is a `Characteristic` with additional `Uint8List value` property.
If there are multiple service/characteristic UUID matches, runs the operation on the first discovered.
```dart
Future<CharacteristicWithValue> readCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  });
```
```dart
  Future<Characteristic> writeCharacteristic(
    String serviceUUID,
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  });
```
```dart
  Stream<CharacteristicWithValue> monitorCharacteristic(
    String serviceUUID,
    String characteristicUUID, {
    String transactionId,
  });
```
### Service
Object representing a unique service associated with unique peripheral, ensured by the internal mechanisms of MultiPlatformBleAdapter.
For ease of use exposes property `peripheral`.
#### Obtaining characteristics
```dart
  Future<List<Characteristic>> characteristics();
```
Returns a list of characteristics this service contains.
#### Characteristic convenience methods
Following operations will be discussed in details **Characteristic** section.
`CharacteristicWithValue` object is a `Characteristic` with additional `Uint8List value` property.

```dart
  Future<Characteristic> writeCharacteristic(
    String characteristicUUID,
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  });
```
```dart
  Future<CharacteristicWithValue> readCharacteristic(String characteristicUUID,
          {String transactionId});
```
```dart
  Stream<CharacteristicWithValue> monitorCharacteristic(
    String characteristicUUID, {
    String transactionId,
  });
```

### Characteristic
Object representing unique characteristic inside a unique service associated with unique peripheral, all ensured by the internal mechanisms of MultiPlatformBleAdapter.
For ease of use exposes property `service`.
Contains following boolean properties:
* `isReadable`
* `isWritableWithResponse`
* `isWritableWithoutResponse`
* `isNotifiable`
* `isIndicatable`

If no `transactionId` has been specified, then it defaults to `null`. 
**IMPORTANT** If previous operation with specified `transactionId` has not yet finished, it will be cancelled immediately.

```dart
  Future<Uint8List> read({String transactionId});
```
Reads the value of the characteristic. Operation is cancellable, meaning the operation's result in Dart can be discarded.
```dart
  Future<void> write(
    Uint8List bytes,
    bool withResponse, {
    String transactionId,
  });
```
Writes value to this characteristic. It is user's responsibility to choose whether write should be done with or without response. Operation is cancellable, meaning the operation's result in Dart can be discarded.
```dart
  Stream<Uint8List> monitor({String transactionId});
```
Operation is cancellable, which allows the user to terminate the notifications from the peripheral for this characteristic.
## Example
```dart
void test() async {
    BleManager manager = BleManager();
    await manager.createClient();
    manager.startPeripheralScan().listen((scanResult) {
        exampleOperation(scanResult.peripheral, manager);
    });
}

void exampleOperation(Peripheral peripheral, BleManager manager) async {
    if (peripheral.name == "SensorTag") {
        manager.stopPeripheralScan();
        await peripheral.connect();
        Uint8List value = await peripheral.read("F000AA00-0451-4000-B000-000000000000", "F000AA01-0451-4000-B000-000000000000");
        print(value);
        peripheral.disconnectOrCancelConnection();
        manager.destroyClient();
    }
}
```
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
