import '../entities/wallet_account.dart';
import '../repositories/wallet_repository.dart';

class TopUp {
  const TopUp(this._repository);

  final WalletRepository _repository;

  Future<WalletAccount> call(double amount) => _repository.topUp(amount);
}
