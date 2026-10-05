import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet_account.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/get_wallet_account.dart';
import '../../domain/usecases/top_up.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  const WalletLoaded({required this.account, required this.transactions});

  final WalletAccount account;
  final List<WalletTransaction> transactions;

  @override
  List<Object?> get props => [account, transactions];
}

class WalletError extends WalletState {
  const WalletError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required GetWalletAccount getWalletAccount,
    required GetTransactions getTransactions,
    required TopUp topUp,
  })  : _getWalletAccount = getWalletAccount,
        _getTransactions = getTransactions,
        _topUp = topUp,
        super(const WalletLoading());

  final GetWalletAccount _getWalletAccount;
  final GetTransactions _getTransactions;
  final TopUp _topUp;

  Future<void> load() async {
    emit(const WalletLoading());
    try {
      final WalletAccount account = await _getWalletAccount();
      final List<WalletTransaction> transactions = await _getTransactions();
      emit(WalletLoaded(account: account, transactions: transactions));
    } catch (error) {
      emit(WalletError(error.toString()));
    }
  }

  Future<void> topUp(double amount) async {
    await _topUp(amount);
    await load();
  }
}
