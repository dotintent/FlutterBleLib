part of internal;

abstract class SimulationManagerBase {
  Map<String, SimulatedPeripheral> _peripherals = Map();
  DartToPlatformBridge _bridge;

  SimulationManagerBase(this._bridge);

  SimulatedPeripheral _peripheralWithServiceId(int id) =>
      _peripherals.values.firstWhere(
        (peripheral) => peripheral.hasService(id),
        orElse: () => null,
      );

  SimulatedPeripheral _peripheralWithCharacteristicId(int id) =>
      _peripherals.values.firstWhere(
        (peripheral) => peripheral.hasCharacteristic(id),
        orElse: () => null,
      );
}

abstract class SimulationManagerBaseWithErrorChecks
    extends SimulationManagerBase with ErrorChecksMixin {
  SimulationManagerBaseWithErrorChecks(DartToPlatformBridge bridge)
      : super(bridge);
}
