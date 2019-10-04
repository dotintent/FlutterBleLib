part of internal;

abstract class SimulationManagerBase {
  Map<String, SimulatedPeripheral> _peripherals = Map();
  DartToPlatformBridge _bridge;

  SimulationManagerBase(this._bridge);
}

abstract class SimulationManagerBaseWithErrorChecks
    extends SimulationManagerBase with ErrorChecksMixin {
  SimulationManagerBaseWithErrorChecks(DartToPlatformBridge bridge)
      : super(bridge);
}