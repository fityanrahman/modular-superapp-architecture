import 'package:contracts/contracts.dart';

import '../entities/wallet_account.dart';
import '../entities/wallet_transaction.dart';

abstract interface class WalletRepository {
  Future<WalletAccount> getAccount();

  Future<List<WalletTransaction>> getTransactions();

  Future<PaymentResult> pay({required double amount, String? description});

  Future<WalletAccount> topUp(double amount);
}
