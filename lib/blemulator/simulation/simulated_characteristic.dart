part of blemulator;

class SimulatedCharacteristic {
  final String uuid;
  final int id;
  SimulatedService service;
  Uint8List _value;
  final String convenienceName;
  final bool isReadable;
  final bool isWritableWithResponse;
  final bool isWritableWithoutResponse;
  final bool isNotifiable;
  bool isNotifying;
  final bool isIndicatable;

  StreamController<Uint8List> _streamController;

  SimulatedCharacteristic({
    @required this.uuid,
    @required Uint8List value,
    this.convenienceName,
    this.isReadable = true,
    this.isWritableWithResponse = true,
    this.isWritableWithoutResponse = true,
    this.isNotifiable = false,
    this.isNotifying = false,
    this.isIndicatable = false,
  }) : id = IdGenerator().nextId() {
    _value = value;
  }

  void attachToService(SimulatedService service) => this.service = service;

  Future<Uint8List> read() async =>
      isReadable ? _value : Future.error("This characteristic is not readable");

  Future<void> write(Uint8List value) async {
    this._value = value;
    if (_streamController?.hasListener == true)
      _streamController.sink.add(value);
  }

  Stream<Uint8List> monitor() {
    if (_streamController == null) {
      _streamController = StreamController.broadcast(
        onListen: () {
          isNotifying = true;
        },
        onCancel: () {
          isNotifying = false;
          _streamController.close();
          _streamController = null;
        },
      );
    }
    return _streamController.stream;
  }
}
