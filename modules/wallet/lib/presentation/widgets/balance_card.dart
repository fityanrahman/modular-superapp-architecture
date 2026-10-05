import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/wallet_account.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.account});

  final WalletAccount account;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Available balance', style: AppTypography.caption),
          const SizedBox(height: 8),
          Text(formatRupiah(account.balance), style: AppTypography.headline),
          const SizedBox(height: 4),
          Text(account.currency, style: AppTypography.caption),
        ],
      ),
    );
  }
}
