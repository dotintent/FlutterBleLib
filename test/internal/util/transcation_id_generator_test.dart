
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ble_lib/internal/util/transaction_id_generator.dart';

void main() {
  test("should be able to generate an id", () {
    expect(TransactionIdGenerator.getNextId(), isNotNull);
  });

  test("should increment id on next invocation", () {
    int previousId = int.parse(TransactionIdGenerator.getNextId());
    expect(TransactionIdGenerator.getNextId(), equals((previousId + 1).toString()));
  });
}