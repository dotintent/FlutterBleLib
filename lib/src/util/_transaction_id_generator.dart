class TransactionIdGenerator {
  static int _id = 0;
  static const TransactionIdGenerator INSTANCE = const TransactionIdGenerator._internal();

  String getNextId() {
    _id++;
    return _id.toString();
  }

  const TransactionIdGenerator._internal();
}


