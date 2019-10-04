part of internal;

mixin DiscoveryMixin on SimulationManagerBaseWithErrorChecks {
  Future<List<SimulatedService>> discovery(String identifier) async {
    await _errorIfUnknown(identifier);
    await _errorIfNotConnected(identifier);

    await _peripherals[identifier].onDiscoveryRequest();
    await _peripherals[identifier].onDiscovery();
    return _peripherals[identifier].services();
  }
}
