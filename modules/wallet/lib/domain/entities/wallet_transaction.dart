import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String type;

  bool get isDebit => amount < 0;

  @override
  List<Object?> get props => [id, title, amount, date, type];
}
