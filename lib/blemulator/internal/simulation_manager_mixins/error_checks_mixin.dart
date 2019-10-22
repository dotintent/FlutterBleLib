part of internal;

mixin ErrorChecksMixin on SimulationManagerBase {
  Future<void> _errorIfConnected(String identifier) async {
    if (_peripherals[identifier].isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceAlreadyConnected,
          "Peripheral $identifier is already connected",
        ),
      );
    }
  }

  Future<void> _errorIfNotConnected(String identifier) async {
    if (!_peripherals[identifier].isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotConnected,
          "Peripheral $identifier is not connected",
        ),
      );
    }
  }

  Future<void> _errorIfDisconnected(String identifier) async {
    if (!_peripherals[identifier].isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceDisconnected,
          "Peripheral $identifier has disconnected",
        ),
      );
    }
  }

  Future<void> _errorIfPeripheralNull(SimulatedPeripheral peripheral) async {
    if (peripheral == null) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotFound,
          "Unknown peripheral",
        ),
      );
    }
  }

  Future<void> _errorIfUnknown(String identifier) async {
    if (_peripherals[identifier] == null) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotFound,
          "Unknown peripheral identifier $identifier",
        ),
      );
    }
  }

  Future<void> _errorIfCannotConnect(String identifier) async {
    bool canConnect = await _peripherals[identifier].onConnectRequest();
    if (!canConnect)
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceConnectionFailed,
          "Connection to peripheral $identifier was denied",
        ),
      );
  }

  Future<void> _errorIfCharacteristicNotReadable(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isReadable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicReadFailed,
          "Characteristic read failed",
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotWritableWithResponse(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithResponse) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed,
          "Characteristic cannot be written to with response",
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotWritableWithoutResponse(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithoutResponse) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed,
          "Characteristic cannot be written to without response",
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotNotifiable(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isIndicatable && !characteristic.isNotifiable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicNotifyChangeFailed,
          "Characteristic ${characteristic.uuid} cannot be monitored",
        ),
      );
    }
  }
}
