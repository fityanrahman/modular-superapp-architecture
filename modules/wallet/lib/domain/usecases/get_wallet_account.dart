import '../entities/wallet_account.dart';
import '../repositories/wallet_repository.dart';

class GetWalletAccount {
  const GetWalletAccount(this._repository);

  final WalletRepository _repository;

  Future<WalletAccount> call() => _repository.getAccount();
}
