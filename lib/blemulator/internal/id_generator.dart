class IdGenerator {
  static final IdGenerator _instance = IdGenerator._internal();
  int _id = 0;

  factory IdGenerator() {
    return _instance;
  }

  IdGenerator._internal();

  int nextId() {
    return _id++;
  }
}