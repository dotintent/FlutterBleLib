part of internal;

mixin ErrorChecksMixin on SimulationManagerBase {
  Future<void> _errorIfConnected(String identifier) async {
    if (_peripherals[identifier].isConnected()) {
      return Future.error(SimulatedBleError(
        BleErrorCode.DeviceAlreadyConnected,
        "Peripheral $identifier is already connected",
      ));
    }
  }

  Future<void> _errorIfNotConnected(String identifier) async {
    if (!_peripherals[identifier].isConnected()) {
      return Future.error(SimulatedBleError(
        BleErrorCode.DeviceNotConnected,
        "Peripheral $identifier is not connected",
      ));
    }
  }

  Future<void> _errorIfUnknown(String identifier) async {
    if (_peripherals[identifier] == null) {
      return Future.error(SimulatedBleError(
        BleErrorCode.DeviceNotFound,
        "Unknown peripheral identifier $identifier",
      ));
    }
  }

  Future<void> _errorIfCannotConnect(String identifier) async {
    bool canConnect = await _peripherals[identifier].onConnectRequest();
    if (!canConnect)
      return Future.error(SimulatedBleError(
        BleErrorCode.DeviceConnectionFailed,
        "Connection to peripheral $identifier was denied",
      ));
  }
}
