import '../../domain/entities/wallet_account.dart';

class WalletAccountModel extends WalletAccount {
  const WalletAccountModel({required super.balance, required super.currency});

  factory WalletAccountModel.fromJson(Map<String, dynamic> json) =>
      WalletAccountModel(
        balance: (json['balance'] as num).toDouble(),
        currency: json['currency'] as String? ?? 'IDR',
      );

  Map<String, dynamic> toJson() => {'balance': balance, 'currency': currency};
}
