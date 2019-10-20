part of internal;

mixin PeripheralRssiMixin on SimulationManagerBaseWithErrorChecks {

  Future<int> _readRssiForDevice(String identifier) async {
    await _errorIfUnknown(identifier);
    await _errorIfNotConnected(identifier);

    int rssi = await _peripherals[identifier].rssi();
    await _errorIfDisconnected(identifier);
    return rssi;
  }
}