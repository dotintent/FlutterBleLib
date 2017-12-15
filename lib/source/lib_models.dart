part of flutter_ble_lib;

class BleDevice {

  String macAddress;
  String name;

  BleDevice(this.macAddress, this.name);

  static BleDevice fromMessage(bleData.BleDeviceMessage bleDeviceMessage) =>
      new BleDevice(bleDeviceMessage.macAddress, bleDeviceMessage.name);
}

class ScanResult {
  BleDevice bleDevice;
  int rssi;
  Int64 timestampNanos;
  int scanCallbackType;

  ScanResult(this.bleDevice,
      this.rssi,
      this.timestampNanos,
      this.scanCallbackType);

  static ScanResult fromMessage(bleData.ScanResultMessage scanResultMessage) =>
      new ScanResult(
          BleDevice.fromMessage(scanResultMessage.bleDeviceMessage),
          scanResultMessage.rssi,
          scanResultMessage.timestampNanos,
          scanResultMessage.scanCallbackTypeMessage);


  bool hasTheSameDeviceAs(ScanResult scanResult) =>
      this.bleDevice.macAddress == scanResult.bleDevice.macAddress;

  update(ScanResult scanResultItem) {
    bleDevice
      ..macAddress = scanResultItem.bleDevice.macAddress
      ..name = scanResultItem.bleDevice.name;
    rssi = scanResultItem.rssi;
    timestampNanos = scanResultItem.timestampNanos;
    scanCallbackType = scanResultItem.scanCallbackType;
  }
}


class ConnectedDevice {
  BleDevice bleDevice;
  int rssi;
  int mtu;

  ConnectedDevice(this.bleDevice,
      this.rssi,
      this.mtu);

  static ConnectedDevice fromMessage(
      bleData.ConnectedDeviceMessage connectedDeviceMessage) =>
      new ConnectedDevice(
          BleDevice.fromMessage(connectedDeviceMessage.deviceMessage),
          connectedDeviceMessage.rssi,
          connectedDeviceMessage.mtu
      );
}