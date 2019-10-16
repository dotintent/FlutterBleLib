part of internal;

mixin PeripheralRssiMixin on SimulationManagerBaseWithErrorChecks {

  Future<int> _readRssiForDevice(String identifier) async {
    await _errorIfUnknown(identifier);
    await _errorIfNotConnected(identifier);

    SimulatedPeripheral peripheral = _peripherals[identifier];
    return peripheral.rssi();
  }
}