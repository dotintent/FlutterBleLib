part of blemulator;

class Blemulator {

  static Blemulator _instance = Blemulator._internal();

  DartToPlatformBridge _toPlatformBridge;
  SimulationManager _simulationManager;
  PlatformToDartBridge _toDartBridge;

  factory Blemulator() => _instance;

  Blemulator._internal() {
    _toPlatformBridge = DartToPlatformBridge();
    _simulationManager = SimulationManager(_toPlatformBridge);
    _toDartBridge = PlatformToDartBridge(_simulationManager);
  }

  Future<void> simulate() => _toPlatformBridge.simulate();

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    _simulationManager.addSimulatedPeripheral(peripheral);
  }

  void removeAllSimulatedPeripherals() {
    _simulationManager.removeAllSimulatedPeripherals();
  }
}