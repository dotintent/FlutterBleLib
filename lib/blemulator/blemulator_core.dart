part of blemulator;

class Blemulator {

  static Blemulator _instance = Blemulator._internal();

  DownstreamBridge _bridge;
  SimulationManager _simulationManager;
  UpstreamBridge _upstreamBridge;

  factory Blemulator() => _instance;

  Blemulator._internal() {
    _bridge = DownstreamBridge();
    _simulationManager = SimulationManager(_bridge);
    _upstreamBridge = UpstreamBridge(_simulationManager);
  }

  Future<void> simulate() => _bridge.simulate();

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    _simulationManager.addSimulatedPeripheral(peripheral);
  }

  void removeAllSimulatedPeripherals() {
    _simulationManager.removeAllSimulatedPeripherals();
  }
}