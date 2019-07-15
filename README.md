<p align="center">
  <img
    alt="FlutterBLE library logo"
    src="site/flutter-ble-lib-logo.png"
    height="300"
    style="margin-top: 20px; margin-bottom: 20px;"
  />
</p>

## ATTENTION

Thank you for your interest in the FlutterBle Library. This repository was not maintained for some time as we were focusing on developing native [iOS (RxBluetoothKit)](https://github.com/Polidea/RxBluetoothKit), [Android (RxAndroidBle)](https://github.com/Polidea/RxAndroidBle) and [React Native (react-native-ble-plx)](https://github.com/Polidea/react-native-ble-plx) libraries. We plan to bring this library back to shape. Stay tuned!

# FlutterBle Library

FlutterBle Library is a Flutter library that supports BLE connections. It internally utilizes [RxAndroidBle](https://github.com/Polidea/RxAndroidBle) and [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit) as native libs, which especially on Android helps a lot with many of known platform issues.

## Getting Started

To start using Flutter, you have to prepare the environment. Here you can find [the tutorial](https://flutter.io/getting-started/) showing how to do this step by step. 

## Library Features
  - [x] Setting log level
  - [x] Listening bluetooth adapter state
  - [x] Scanning devices
  - [x] Establish connection
  - [x] Listening to connection state changes
  - [x] Discovering services
  - [x] Reading characteristics
  - [x] Writing characteristics
  - [x] Listening to characteristic change notifications

## Configuration & Installation
Add the snippet below to your `pubspec.yaml` file:
```
dependencies:
  flutter_ble_lib: "^1.0.0"
```
Package can be installed from the command line:

- with pub: `$ pub get`
- with Flutter: `$ flutter packages get`

Alternatively, your editor may support `pub get` or `packages get`. Refer to the documentation of your IDE to learn more.

### iOS additional configuration
In order to make it work on iOS you need to make 2 additional steps:
- add `use_frameworks!` at the beginning of `ios/Podfile` file
- add `config.build_settings['SWIFT_VERSION'] = '4.1.0'` in `post_install` block of `ios/Podfile` file

Finally your `ios/Podfile` file should have following changes:
```
+ use_frameworks!

...

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
+      config.build_settings['SWIFT_VERSION'] = '4.1.0'
    end
  end
end
```

## Usage

Once the package is installed you can use:

`import 'package:flutter_ble_lib/flutter_ble_lib.dart';`

### Create Client

First, you need to create a client. It is very important to maintain only one instance of the client in your application. You can do this via the method 

    FlutterBleLib.instance.createClient(restoreId);

### Set up log level

After creating the client, you can set up a log level. There are a few defined log levels:
- NONE (default value)
- VERBOSE
- DEBUG
- INFO
- WARNING
- ERROR

You can set the log level via 

    FlutterBleLib.instance.setLogLevel(logLevel);
    
and. You can also check the current level log via: 
  
    FlutterBleLib.instance.logLevel();


### Bluetooth state checking

The library allows checking a Bluetooth state. You can register a listener that informs about state changes. It is possible via:
 
    FlutterBleLib.instance.onStateChange()
     
This method returns a stream that emits all Bluetooth state changes. If you want to get current Bluetooth state you can just call the method below
 
    FlutterBleLib.instance.state()
     
Methods presented above may return/emit the following values:
- UNKNOWN (default state)
- RESETTING
- UNSUPPORTED 
- UNAUTHORIZED
- POWERED_OFF
- POWERED_ON

### The connection with the device

After creating the client, you can establish a connection with the device. There is a feature to scan for devices via: 
 
    FlutterBleLib.instance.startDeviceScan(scanMode, calbackType, uuidsArray)
     
method. This method returns a stream that emits scanned devices. The information about a device contains a `device id` that may be used to create the connection. All you need to do is to call: 

    FlutterBleLib.instance.connectToDevice(deviceId, isAutoConnect)
     
method. As a response you will get an information about the connected device. You can verify if the device is connected via 
 
    FlutterBleLib.instance.isDeviceConnected(deviceId)

at any time. It is recommended to set up a monitor that allows getting an information about the connection being broken. The library provides this functionality via the following method 

    FlutterBleLib.instance.onDeviceConnectionChanged()
     
If any of the device connection breaks the stream emits information about it.<br />

Once you are connected to your device, you can discover services, write, read or listen to notifications from characteristics.

Full library functionality is shown in example app.

## Maintainers
Konrad Krakowiak (konrad.krakowiak@polidea.com)<br/>
Michał Mizera (michal.mizera@polidea.com)<br/>
Michał Zieliński (michal.zielinski@polidea.com)<br/>
Paweł Janeczek (pawel.janeczek@polidea.com)

## License

    Copyright 2018 Polidea Sp. z o.o

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## Maintained by

[Polidea](http://www.polidea.com)

Learn more about Polidea's BLE services [here](https://www.polidea.com/services/ble).
