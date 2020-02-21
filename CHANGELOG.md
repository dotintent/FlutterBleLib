## 2.2.1

* Hide private APIs
* Add setup instructions to README
* Add missing descriptor operations information to README
* Moved permission_handler dependency to its place in example

## 2.2.0

* **NEW** operations on descriptors
* **BREAKING FOR BLEMULATOR** BLEmulator versions lower than 1.1.0 are not supported from this release
* Support for AndroidX
* Support for Swift 5
* Lower iOS deployment target to 8.0

## 2.1.0

* **BREAKING** ScanResult.AdvertisementData.ManufacturerData has changed type from Int8List to Uint8List
* Fix issue with invalid value of manufacturer data in scan results
* Fix issue with initialising plugin from a service without an active activity
* Update README with information about permissions
* Fix issue with default value of MTU when connecting to a peripheral on Android
* Fix issue where first few notifications right after start of monitoring a characteristic could get lost

## 2.0.1

* Fix issue with automatically generated transaction IDs.

## 2.0.0

* Dart 2.0 support
* **BREAKING** Completely new API. Consult [README](https://github.com/Polidea/FlutterBleLib/blob/master/README.md) for instructions on how to use the new version.
* Added [BLEmulator](https://github.com/Polidea/blemulator_flutter) support
