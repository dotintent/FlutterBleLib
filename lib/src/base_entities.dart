part of _internal;

class InternalService {
  int _id;

  InternalService(this._id);
}

class InternalCharacteristic {
  int _id;

  InternalCharacteristic(this._id);
}

class InternalDescriptor {
  int _id;

  InternalDescriptor(this._id);
}

mixin WithValue {
  /// The value of this object.
  Uint8List value;
}
