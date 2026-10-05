import 'package:contracts/contracts.dart';

import '../../domain/entities/wallet_account.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';
import '../models/wallet_account_model.dart';
import '../models/wallet_transaction_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._remote);

  final WalletRemoteDataSource _remote;

  WalletAccount? _account;
  List<WalletTransaction>? _transactions;
  int _counter = 0;

  @override
  Future<WalletAccount> getAccount() async {
    final WalletAccount? account = _account;
    if (account != null) {
      return account;
    }
    final Map<String, dynamic> json = await _remote.fetchAccount();
    final WalletAccountModel model = WalletAccountModel.fromJson(json);
    _account = model;
    return model;
  }

  @override
  Future<List<WalletTransaction>> getTransactions() async {
    final List<WalletTransaction>? transactions = _transactions;
    if (transactions != null) {
      return transactions;
    }
    final List<Map<String, dynamic>> rows = await _remote.fetchTransactions();
    final List<WalletTransaction> loaded = rows
        .map(WalletTransactionModel.fromJson)
        .toList();
    _transactions = loaded;
    return loaded;
  }

  @override
  Future<PaymentResult> pay({
    required double amount,
    String? description,
  }) async {
    final WalletAccount account = await getAccount();
    if (account.balance < amount) {
      return const PaymentResult.failure(message: 'Insufficient balance');
    }
    await getTransactions();

    final WalletTransaction transaction = _record(
      title: description ?? 'Payment',
      amount: -amount,
      type: 'debit',
    );
    _account = WalletAccount(
      balance: account.balance - amount,
      currency: account.currency,
    );
    return PaymentResult.success(amount: amount, transactionId: transaction.id);
  }

  @override
  Future<WalletAccount> topUp(double amount) async {
    final WalletAccount account = await getAccount();
    await getTransactions();
    _record(title: 'Top up', amount: amount, type: 'credit');
    final WalletAccount updated = WalletAccount(
      balance: account.balance + amount,
      currency: account.currency,
    );
    _account = updated;
    return updated;
  }

  WalletTransaction _record({
    required String title,
    required double amount,
    required String type,
  }) {
    _counter++;
    final WalletTransaction transaction = WalletTransaction(
      id: 'TRX-$_counter',
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
    );
    _transactions = [transaction, ...?_transactions];
    return transaction;
  }
}
