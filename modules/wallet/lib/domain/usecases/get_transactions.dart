import '../entities/wallet_transaction.dart';
import '../repositories/wallet_repository.dart';

class GetTransactions {
  const GetTransactions(this._repository);

  final WalletRepository _repository;

  Future<List<WalletTransaction>> call() => _repository.getTransactions();
}
