import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/wallet_transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final bool isDebit = transaction.isDebit;
    return AppCard(
      child: Row(
        children: [
          Icon(
            isDebit ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebit ? AppColors.danger : AppColors.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTypography.title),
                const SizedBox(height: 4),
                Text(
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            formatRupiah(transaction.amount),
            style: AppTypography.body.copyWith(
              color: isDebit ? AppColors.danger : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
