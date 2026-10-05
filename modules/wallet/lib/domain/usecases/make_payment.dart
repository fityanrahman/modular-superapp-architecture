import 'package:contracts/contracts.dart';

import '../repositories/wallet_repository.dart';

class MakePayment {
  const MakePayment(this._repository);

  final WalletRepository _repository;

  Future<PaymentResult> call({required double amount, String? description}) =>
      _repository.pay(amount: amount, description: description);
}
