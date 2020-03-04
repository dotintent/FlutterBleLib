class TransactionIdGenerator {
  static int _id = 0;


  const TransactionIdGenerator();

  String getNextId() {
    _id++;
    return _id.toString();
  }
}
