part of blemulator;

class SimulatedService {
  final String uuid;
  final int id;
  final bool isAdvertised;
  Map<int, SimulatedCharacteristic> _characteristics;

  SimulatedService(this.uuid, this.isAdvertised,
      List<SimulatedCharacteristic> characteristics)
      : _characteristics = Map.fromIterable(characteristics, key: (v) => v.id),
        id = 0 {
    _characteristics.values.forEach((v) => v.attachToService(this));
  }

  List<SimulatedCharacteristic> characteristics() =>
      _characteristics.values.toList();

  SimulatedCharacteristic characteristic(int id) => _characteristics[id];
}