class PaymentResult {
  const PaymentResult({
    required this.success,
    required this.message,
    required this.amount,
    this.transactionId,
  });

  const PaymentResult.success({
    required this.amount,
    required this.transactionId,
    this.message = 'Payment successful',
  }) : success = true;

  const PaymentResult.failure({
    required this.message,
    this.amount = 0,
  })  : success = false,
        transactionId = null;

  final bool success;
  final String message;
  final double amount;
  final String? transactionId;
}
