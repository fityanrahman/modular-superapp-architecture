import 'package:equatable/equatable.dart';

class WalletAccount extends Equatable {
  const WalletAccount({
    required this.balance,
    required this.currency,
  });

  final double balance;
  final String currency;

  @override
  List<Object?> get props => [balance, currency];
}
