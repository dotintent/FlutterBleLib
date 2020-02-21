# Overview

The library is organised around a few base entities, which are:
* **BleManager**
* **Peripheral**
* **Service**
* **Characteristic**

The basic idea is to create an instance of **BleManager**, use it to create/release native clients of the underlying libraries, scan for peripherals and then operate on **Peripheral**.


# BleManager

This entity serves as the library's entry point. It doesn't track any state, so it is safe to create as many of those as you wish.
All of the following methods belong to BleManager instance.

## Managing native resources

```dart
  Future<void> createClient({
    String restoreStateIdentifier,
    RestoreStateAction restoreStateAction,
  });
```

Creates native adapters for handling BLE. *This method has to be called before you can begin using the library.*
Both parameters are iOS-specific and handle restoration of already bonded devices, eg. after a crash.

Method will return error if an instance of native BleAdapter has already been created.

```dart
  Future<void> destroyClient();
```

Releases native resources. Should be called once there's no further need for BLE capabilities.

## Scanning for peripherals

```dart
  Stream<ScanResult> startPeripheralScan({
    int scanMode,
    int callbackType,
    List<String> uuids,
    bool allowDuplicates,
  });
```

`scanMode` and `callbackType` are Android-specific. [More information in Android documentation](https://developer.android.com/reference/android/bluetooth/le/ScanSettings)
`allowDuplicates` is iOS-specific. [More information in iOS documentation](https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerscanoptionallowduplicateskey)
`uuids` is used to filter peripherals to only return those containing services with specified UUIDs.

Returns a stream of objects containing advertisement data of the peripheral and the peripheral itself called `ScanResult`. The object has two iOS-only fields: `isConnectable` and `overflowServiceUuids`. 

```dart
  Future<void> stopDeviceScan();
```

Ends peripheral scan.

## Managing log level

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

## Managing radio state

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

## Listing known devices

```dart
  Future<List<Peripheral>> knownDevices(List<String> peripheralIdentifiers);
```

Return a list of Peripherals that have been scanned and match any of the supplied identifiers. Returns empty list if an empty list is passed.

```dart
  Future<List<Peripheral>> connectedDevices(List<String> serviceUUIDs);

```

Returns a list of connected Peripherals that have at least one service with UUID matching any of the supplied UUIDs. Returns empty list if an empty list is passed.

## Cancelling asynchronous operations

```dart
  Future<void> cancelTransaction(String transactionId);
```
Some of the asynchronous operations done by the library do not have a complementary `stop...()` function, but accept an optional parameter `transactionId`, eg. reading from characteristic. This function allows the user to break the execution of such operation, which will immediately return with BleError and errorCode `operationCancelled`.

**IMPORTANT**
The cancelled operation will still be completed (perhaps with error), but the user will not be notified about its result.

_(Read more about [transactions](https://github.com/Polidea/FlutterBleLib/#transactions))_

# Peripheral

Object representing a peripheral. Allows for managing connection, discovery and serves as a shortcut to characteristic operations, if the user knows the UUIDs of both service and characteristic.
All of the following methods belong to Peripheral instance.

## Connection

```dart
  Future<void> connect(
          {bool isAutoConnect = false,
          int requestMtu,
          bool refreshGatt = false,
          Duration timeout});
```
Attempts to connect to the peripheral.

`autoConnect` waits for device to be discoverable before attempting connection; Android-specific. [See more](https://github.com/Polidea/RxAndroidBle#auto-connect) 

`requestMtu` defaults to 0, which means the library won't set it. Valid values according to BLE specification are between 23 and 512. **IMPORTANT** can be requested only once: if you pass this argument, then every call to `requestMtu()` will fail. 

`refreshGatt` forces GATT to refresh its cache; Android-specific.

If connection has not been established by `timeout`, the operation fails. `timeout` defaults to 30 seconds.

```dart
  Stream<PeripheralConnectionState> observeConnectionState(
          {bool emitCurrentValue = false,
          bool completeOnDisconnect = false});
```

Returns a stream containing changes to the connection state. By default doesn't emit current state, nor terminates the stream after disconnecting.
**Note:** due ambiguities concerning `disconnecting` state, current implementation never emits `disconnecting`, only `connecting`, `connected`, `disconnected`.

```dart
  Future<bool> isConnected();
```

Returns true if the peripheral is currently connected.

```dart
  Future<void> disconnectOrCancelConnection();
```

Terminates connection or any attempt to connect.

## Obtaining services, characteristics and descriptors

```dart
  Future<void> discoverAllServicesAndCharacteristics({String transactionId});
```

Runs the discovery process, caching all discovered services and characteristics in the native parts.
**Must be run before `services()`, `characteristics()` and any operations on characteristics**
Operation is cancellable, meaning the operation's result in Dart can be discarded.

```dart
  Future<List<Service>> services();
```

Returns a list of all discovered services for the peripheral.
Fails if discovery has not been done.

```dart
  Future<List<Characteristic>> characteristics(String servicedUuid);
```

Returns a list of all discovered characteristics for the specified service of the peripheral.
Fails if discovery has not been done.

```dart
  Future<List<Descriptor>> descriptorsForCharacteristic(
    String serviceUuid,
    String characteristicUuid,
  );
```

Returns a list of all descriptors of the specified characteristic. Returns first match encountered, if there are UUID conflicts.

## RSSI and MTU

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

Request peripheral to set a different MTU. On iOS only returns the current value.
Returns the MTU set by peripheral after the request.

MTU can be requested only once in the lifetime of the connection, meaning this call will fail if it was set prior by either passing a valid value to `connect(requestMtu: int)` or calling this function.

## Characteristic convenience methods

Finds first service with specified UUID and first characteristic
 in said service with specified UUID and then performs the requested operation.
 Following operations will be discussed in details in **Characteristic** section.
`CharacteristicWithValue` object is a `Characteristic` with additional `Uint8List value` property.

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

# Service

Object representing a unique service associated with unique peripheral, ensured by the internal mechanisms of MultiPlatformBleAdapter.
For ease of use exposes property `peripheral`.
All of the following methods belong to Service instance.

## Obtaining characteristics

```dart
  Future<List<Characteristic>> characteristics();
```

Returns a list of characteristics this service contains.

## Characteristic convenience methods

Following operations will be discussed in details **Characteristic** section.
Finds first characteristic with specified UUID and then performs the requested operation.
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

# Characteristic

Object representing unique characteristic inside a unique service associated with unique peripheral, all ensured by the internal mechanisms of MultiPlatformBleAdapter.
For ease of use exposes property `service`.
Contains following boolean properties:
* `isReadable`
* `isWritableWithResponse`
* `isWritableWithoutResponse`
* `isNotifiable`
* `isIndicatable`


All of the following methods belong to Characteristic instance.

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

Writes value to this characteristic. It is user's responsibility to choose whether write should be done with or without response.

```dart
  Stream<Uint8List> monitor({String transactionId});
```

Operation is cancellable, which allows the user to terminate the notifications from the peripheral for this characteristic.

# Descriptor

Object representing unique descriptor inside unique characteristic inside a unique service associated with unique peripheral, all ensured by the internal mechanisms of MultiPlatformBleAdapter.

For ease of use exposes `characteristic` property.

```dart
  Future<Uint8List> read({String transactionId});
```

```dart
  Future<void> write(Uint8List value, {String transactionId})
```