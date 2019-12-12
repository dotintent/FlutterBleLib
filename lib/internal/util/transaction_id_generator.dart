abstract class TransactionIdGenerator {
  static int _id;

  static String getNextId() {
    _id++;
    return _id.toString();
  }
}
