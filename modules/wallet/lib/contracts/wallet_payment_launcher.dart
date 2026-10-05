import 'package:contracts/contracts.dart';

import '../domain/repositories/wallet_repository.dart';

class WalletPaymentLauncher implements PaymentLauncher {
  WalletPaymentLauncher(this._repository);

  final WalletRepository _repository;

  @override
  Future<PaymentResult> pay({required double amount, String? description}) =>
      _repository.pay(amount: amount, description: description);
}
