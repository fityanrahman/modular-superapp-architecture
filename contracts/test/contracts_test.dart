import 'package:contracts/contracts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentResult', () {
    test('success factory marks the payment as successful', () {
      const result = PaymentResult.success(
        amount: 25000,
        transactionId: 'TRX-1',
      );

      expect(result.success, isTrue);
      expect(result.transactionId, 'TRX-1');
      expect(result.amount, 25000);
    });

    test('failure factory marks the payment as failed', () {
      const result = PaymentResult.failure(message: 'Insufficient balance');

      expect(result.success, isFalse);
      expect(result.transactionId, isNull);
      expect(result.message, 'Insufficient balance');
    });
  });
}
