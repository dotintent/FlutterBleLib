part of internal;

mixin ErrorChecksMixin on SimulationManagerBase {
  Future<void> _errorIfConnected(String identifier) async {
    if (_peripherals[identifier].isConnected()) {
      return Future.error(<String, dynamic>{
        "errorCode": BleErrorCode.DeviceAlreadyConnected,
        "reason": "Peripheral $identifier is already connected",
      });
    }
  }

  Future<void> _errorIfNotConnected(String identifier) async {
    if (!_peripherals[identifier].isConnected()) {
      return Future.error(<String, dynamic>{
        "errorCode": BleErrorCode.DeviceNotConnected,
        "reason": "Peripheral $identifier is not connected",
      });
    }
  }

  Future<void> _errorIfUnknown(String identifier) async {
    if (_peripherals[identifier] == null) {
      return Future.error(<String, dynamic>{
        "errorCode": BleErrorCode.DeviceNotFound,
        "reason": "Unknown peripheral identifier $identifier",
      });
    }
  }

  Future<void> _errorIfCannotConnect(String identifier) async {
    bool canConnect = await _peripherals[identifier].onConnectRequest();
    if (!canConnect)
      return Future.error(<String, dynamic>{
        "errorCode": BleErrorCode.DeviceConnectionFailed,
        "reason": "Connection to peripheral $identifier was denied",
      });
  }
}