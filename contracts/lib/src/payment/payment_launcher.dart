import 'payment_result.dart';

abstract interface class PaymentLauncher {
  Future<PaymentResult> pay({
    required double amount,
    String? description,
  });
}
