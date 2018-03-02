<p align="center">
  <img src="site/flutter-ble-lib-logo.png" />
</p>

# FlutterBle Library

FlutterBle Library is a flutter library that supports ble connections. It uses [RxAndroidBle](https://github.com/Polidea/RxAndroidBle) and [RxBluetoothKit](https://github.com/Polidea/RxBluetoothKit) as native libs.

## Getting Started

To using Flutter you need to prepare the environment. Here you can find [the tutorial](https://flutter.io/getting-started/) showing how to do this, step by step. 

## Features
  - [x] Setting log level
  - [x] Listening bluetooth state
  - [x] Scanning devices
  - [x] Establish connection
  - [x] Listening connection state changes
  - [x] Reading services
  - [x] Reading characteristics
  - [x] Writing characteristics
  - [x] Listening characteristic notifications

## Usage

### Create Client

Firstly you need create client. It is very important to create only one single instance. You can do this via method 

    FlutterBleLib.instance.createClient(restoreId);

### Set up log level

After creating the client, you can set up log level. There are a few defined log levels:
- NONE (default value)
- VERBOSE
- DEBUG
- INFO
- WARNING
- ERROR

You can set log level via 

    FlutterBleLib.instance.setLogLevel(logLevel);
    
and, you will get set log level  as the response. You can also check current level log via: 
  
    FlutterBleLib.instance.logLevel();


### Bluetooth state checking

Library allows to check bluetooth state. You can register listener that informs about state changes. It is possible via:
 
    FlutterBleLib.instance.onStateChange()
     
 This method returns stream that emits all bluetooth state changes. It is not the only one way to get information about bluetooth state. If you want to get current bluetooth state you can just call method 
 
    FlutterBleLib.instance.state()
     
to get current state.

There is a few defined current state:
- UNKNOWN (default state)
- RESETTING
- UNSUPPORTED 
- UNAUTHORIZED
- POWERED_OFF
- POWERED_ON

### The connection with the device

After creating client, you can establish connection with device. There is possibility to scan all devices via: 
 
    FlutterBleLib.instance.startDeviceScan(scanMode, calbackType, uuidsArray)
     
method. This method returns stream that emits scanned devices. The information about the device contains device id that is used to create connection. All you need to do is calling: 

    FlutterBleLib.instance.connectToDevice(deviceId, isAutoConnect)
     
 method, as a response you will get information about connected device. You can check any time that device is connected via 
 
    FlutterBleLib.instance.isDeviceConnected(deviceId)

at any time. It’s good to set up the monitor that allows to get the information about breaking connection. Library provides this functionality via the following method 

    FlutterBleLib.instance.onDeviceConnectionChanged()
     
 If some of the device's brake, this stream will emit information about this device.<br />

When you are connected with your device you can discover services, write, read or listen notification from characteristic via relevant method.

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