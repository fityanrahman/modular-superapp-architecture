import 'package:contracts/contracts.dart';

class MockPaymentLauncher implements PaymentLauncher {
  const MockPaymentLauncher({
    this.shouldSucceed = true,
    this.delay = const Duration(milliseconds: 700),
  });

  final bool shouldSucceed;
  final Duration delay;

  @override
  Future<PaymentResult> pay({
    required double amount,
    String? description,
  }) async {
    await Future<void>.delayed(delay);
    if (!shouldSucceed) {
      return const PaymentResult.failure(message: 'Mock payment declined');
    }
    return PaymentResult.success(
      amount: amount,
      transactionId: 'MOCK-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
