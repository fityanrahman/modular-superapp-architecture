import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet_account.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../bloc/wallet_cubit.dart';
import '../wallet_dependencies.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import 'wallet_payment_page.dart';

class WalletHomePage extends StatefulWidget {
  const WalletHomePage({super.key, required this.dependencies});

  final WalletDependencies dependencies;

  @override
  State<WalletHomePage> createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  @override
  void initState() {
    super.initState();
    widget.dependencies.analytics.track('wallet_opened');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).maybePop(),
        ),
        title: const Text('Wallet'),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return switch (state) {
            WalletLoading() => const AppLoading(message: 'Loading wallet...'),
            WalletError(:final String message) => AppErrorView(
                message: message,
                onRetry: () => context.read<WalletCubit>().load(),
              ),
            WalletLoaded(
              :final WalletAccount account,
              :final List<WalletTransaction> transactions,
            ) =>
              _WalletContent(
                account: account,
                transactions: transactions,
                onTopUp: () => _topUp(context),
                onPayment: () => _openPayment(context),
              ),
          };
        },
      ),
    );
  }

  void _topUp(BuildContext context) {
    widget.dependencies.analytics.track('wallet_top_up', {'amount': 50000});
    context.read<WalletCubit>().topUp(50000);
  }

  void _openPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WalletPaymentPage(dependencies: widget.dependencies),
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent({
    required this.account,
    required this.transactions,
    required this.onTopUp,
    required this.onPayment,
  });

  final WalletAccount account;
  final List<WalletTransaction> transactions;
  final VoidCallback onTopUp;
  final VoidCallback onPayment;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BalanceCard(account: account),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Top up ${formatRupiah(50000)}',
                icon: Icons.add,
                onPressed: onTopUp,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Make a payment',
                icon: Icons.payments_outlined,
                onPressed: onPayment,
              ),
            ],
          );
        }
        return TransactionTile(transaction: transactions[index - 1]);
      },
    );
  }
}
