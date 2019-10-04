part of blemulator;

class SimulatedCharacteristic {
  final String uuid;
  final int id;
  SimulatedService service;
  Uint8List value;
  final String convenienceName;
  bool isReadable;
  bool isWritableWithResponse;
  bool isWritableWithoutResponse;
  bool isNotifiable;
  bool isIndicatable;

  StreamController<Uint8List> _streamController;

  SimulatedCharacteristic({
    @required this.uuid,
    @required this.value,
    this.convenienceName,
    this.isReadable = true,
    this.isWritableWithResponse = true,
    this.isWritableWithoutResponse = true,
    this.isNotifiable = false,
    this.isIndicatable = false,
  }) : id = IdGenerator().nextId();

  void attachToService(SimulatedService service) => this.service = service;

  Future<Uint8List> read() async =>
      isReadable ? value : Future.error("This characteristic is not readable");

  void write(Uint8List value) {
    this.value = value;
    if (_streamController?.hasListener == true)
      _streamController.sink.add(value);
  }

  Stream<Uint8List> monitor() {
    if (_streamController == null) {
      _streamController = StreamController(onCancel: () {
        _streamController.close();
        _streamController = null;
      });
    }
    return _streamController.stream.asBroadcastStream();
  }
}
