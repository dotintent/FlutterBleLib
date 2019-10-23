part of internal;

class CharacteristicResponse {
  SimulatedCharacteristic characteristic;
  Uint8List value;

  CharacteristicResponse(this.characteristic, this.value);
}