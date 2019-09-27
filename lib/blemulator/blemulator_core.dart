part of blemulator;

class Blemulator {

  static Blemulator _instance = Blemulator._internal();

  BlemulatorBridge _bridge;
  SimulationManager _simulationManager;

  factory Blemulator() => _instance;

  Blemulator._internal() {
    _bridge = BlemulatorBridge();
    _simulationManager = SimulationManager(_bridge);
    SimulatorCallHandler callHandler = SimulatorCallHandler(_simulationManager);
    _bridge.setUpstreamMethodCallHandler(callHandler);
  }

  Future<void> simulate() => _bridge.simulate();

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    _simulationManager.addSimulatedPeripheral(peripheral);
  }

  void removeAllSimulatedPeripherals() {
    _simulationManager.removeAllSimulatedPeripherals();
  }
}