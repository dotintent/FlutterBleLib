part of internal;

mixin ClientManagingMixin on SimulationManagerBase {
  Future<void> _createClient() async {}

  Future<void> _destroyClient() async {}
}
