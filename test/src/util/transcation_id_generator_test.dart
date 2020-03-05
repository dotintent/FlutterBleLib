import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ble_lib/src/util/_transaction_id_generator.dart';

void main() {

  TransactionIdGenerator transactionIdGenerator;

  setUp((){
    transactionIdGenerator = TransactionIdGenerator.INSTANCE;
  });

  test("should be able to generate an id", () {
    expect(transactionIdGenerator.getNextId(), isNotNull);
  });

  test("should always return unique values", () {
    List<String> generatedIds = [];
    for (var i = 0; i < 1000; i++) {
      var generatedId = transactionIdGenerator.getNextId();
      expect(generatedIds, isNot(contains(generatedId)));
      generatedIds.add(generatedId);
    }
  });
}