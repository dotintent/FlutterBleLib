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

  StreamController<Uint8List> streamController;

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
    if (streamController?.hasListener == true)
      streamController.sink.add(value);
  }

  Stream<Uint8List> monitor() {
    if (!isNotifiable) {
      streamController.sink.addError("Characterisitc is not notifiable");
    }
    if (streamController == null) {
      streamController = StreamController(onCancel: () {
        streamController.close();
        streamController = null;
      });
    }
    return streamController.stream.asBroadcastStream();
  }
}

class CharacteristicResponse {
  SimulatedCharacteristic characteristic;
  Uint8List value;

  CharacteristicResponse(this.characteristic, this.value);
}
