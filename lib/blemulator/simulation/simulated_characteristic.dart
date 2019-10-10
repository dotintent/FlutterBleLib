part of blemulator;

class SimulatedCharacteristic {
  final String uuid;
  final int id;
  SimulatedService service;
  Uint8List _value;
  final String convenienceName;
  bool isReadable;
  bool isWritableWithResponse;
  bool isWritableWithoutResponse;
  bool isNotifiable;
  bool isNotifying;
  bool isIndicatable;

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
    if (!isWritableWithResponse || !isWritableWithoutResponse) {
      return Future.error("This characteristic is not writeable");
    }
    this._value = value;
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

class CharacteristicResponse {
  SimulatedCharacteristic characteristic;
  Uint8List value;

  CharacteristicResponse(this.characteristic, this.value);
}
