part of internal;

mixin DiscoveryMixin on SimulationManagerBaseWithErrorChecks {
  Future<List<SimulatedService>> discoverAllServicesAndCharacteristics(
      String deviceIdentifier) async {
    await _errorIfUnknown(deviceIdentifier);
    await _errorIfNotConnected(deviceIdentifier);

    await _peripherals[deviceIdentifier].onDiscoveryRequest();
    await _peripherals[deviceIdentifier].onDiscovery();
    return _peripherals[deviceIdentifier].services();
  }
}
