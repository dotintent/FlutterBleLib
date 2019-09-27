part of blemulator;

class Blemulator {

  BlemulatorBridge _bridge;
  List<SimulatedPeripheral> _peripherals = [];

  Blemulator() {
    _bridge = BlemulatorBridge();
  }

  Future<void> simulate() => _bridge.simulate();

  void addSimulatedPeripheral(SimulatedPeripheral peripheral) {
    _peripherals.add(peripheral);
  }

  void removeAllSimulatedPeripherals() {
    _peripherals.clear();
    //TODO notify bridge?
  }
}