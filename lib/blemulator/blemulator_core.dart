part of blemulator;

class Blemulator {

  BlemulatorBridge _bridge;

  Blemulator() {
    _bridge = BlemulatorBridge();
  }

  Future<void> simulate() => _bridge.simulate();
}