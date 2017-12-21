part of flutter_ble_lib;

class BleDevice {

  String macAddress;
  String name;
  bool isConnected = false;

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
          BleDevice.fromMessage(connectedDeviceMessage.deviceMessage)
            ..isConnected = true,
          connectedDeviceMessage.rssi,
          connectedDeviceMessage.mtu
      );
}

enum LogLevel {
  VERBOSE,
  DEBUG,
  INFO,
  WARNING,
  ERROR,
  NONE,
}

class LogLevelConverter {
  static LogLevel fromMessage(bleData.LogLevelMessage logLevelMessage) {
    switch (logLevelMessage) {
      case bleData.LogLevelMessage.VERBOSE :
        return LogLevel.VERBOSE;
      case bleData.LogLevelMessage.DEBUG :
        return LogLevel.DEBUG;
      case bleData.LogLevelMessage.INFO :
        return LogLevel.INFO;
      case bleData.LogLevelMessage.WARNING :
        return LogLevel.WARNING;
      case bleData.LogLevelMessage.ERROR :
        return LogLevel.ERROR;
      case bleData.LogLevelMessage.NONE :
        return LogLevel.NONE;
      default :
        throw new Exception("Invalid argument $logLevelMessage");
    }
  }

  static bleData.LogLevelMessage toMessage(LogLevel logLevel) {
    switch (logLevel) {
      case LogLevel.VERBOSE :
        return bleData.LogLevelMessage.VERBOSE;
      case LogLevel.DEBUG :
        return bleData.LogLevelMessage.DEBUG;
      case LogLevel.INFO :
        return bleData.LogLevelMessage.INFO;
      case LogLevel.WARNING :
        return bleData.LogLevelMessage.WARNING;
      case LogLevel.ERROR :
        return bleData.LogLevelMessage.ERROR;
      case LogLevel.NONE :
        return bleData.LogLevelMessage.NONE;
      default :
        throw new Exception("Invalid argument $logLevel");
    }
  }
}


enum BluetoothState {
  UNKNOWN,
  RESETTING,
  UNSUPPORTED,
  UNAUTHORIZED,
  POWERED_OFF,
  POWERED_ON,
}


class BluetoothStateConverter {
  static BluetoothState fromMessage(
      bleData.BluetoothStateMessage bluetoothStateMessage) {
    switch (bluetoothStateMessage) {
      case bleData.BluetoothStateMessage.UNKNOWN :
        return BluetoothState.UNKNOWN;
      case bleData.BluetoothStateMessage.RESETTING :
        return BluetoothState.RESETTING;
      case bleData.BluetoothStateMessage.UNSUPPORTED :
        return BluetoothState.UNSUPPORTED;
      case bleData.BluetoothStateMessage.UNAUTHORIZED :
        return BluetoothState.UNAUTHORIZED;
      case bleData.BluetoothStateMessage.POWERED_OFF :
        return BluetoothState.POWERED_OFF;
      case bleData.BluetoothStateMessage.POWERED_ON :
        return BluetoothState.POWERED_ON;
      default :
        throw new Exception("Invalid argument $bluetoothStateMessage");
    }
  }

  static bleData.BluetoothStateMessage toMessage(
      BluetoothState bluetoothState) {
    switch (bluetoothState) {
      case BluetoothState.UNKNOWN :
        return bleData.BluetoothStateMessage.UNKNOWN;
      case BluetoothState.RESETTING :
        return bleData.BluetoothStateMessage.RESETTING;
      case BluetoothState.UNSUPPORTED :
        return bleData.BluetoothStateMessage.UNSUPPORTED;
      case BluetoothState.UNAUTHORIZED :
        return bleData.BluetoothStateMessage.UNAUTHORIZED;
      case BluetoothState.POWERED_OFF :
        return bleData.BluetoothStateMessage.POWERED_OFF;
      case BluetoothState.POWERED_ON :
        return bleData.BluetoothStateMessage.POWERED_ON;
      default :
        throw new Exception("Invalid argument $bluetoothState");
    }
  }
}

