import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/payment_cubit.dart';
import '../wallet_dependencies.dart';
import 'transaction_result_page.dart';

class WalletPaymentPage extends StatefulWidget {
  const WalletPaymentPage({super.key, required this.dependencies});

  final WalletDependencies dependencies;

  @override
  State<WalletPaymentPage> createState() => _WalletPaymentPageState();
}

class _WalletPaymentPageState extends State<WalletPaymentPage> {
  static const List<double> _amounts = [25000, 50000, 100000];

  double _amount = _amounts.first;

  @override
  void initState() {
    super.initState();
    widget.dependencies.analytics.track('wallet_payment_started');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCubit>(
      create: (_) => PaymentCubit(widget.dependencies.makePayment),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => TransactionResultPage(result: state.result),
              ),
            );
          } else if (state is PaymentFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Payment')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Choose an amount', style: AppTypography.headline),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final double amount in _amounts)
                          ChoiceChip(
                            label: Text(formatRupiah(amount)),
                            selected: _amount == amount,
                            onSelected: (_) => setState(() => _amount = amount),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Paid through the WalletRepository shared with the host.',
                      style: AppTypography.caption,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Pay ${formatRupiah(_amount)}',
                      icon: Icons.lock_outline,
                      isLoading: state is PaymentProcessing,
                      onPressed: () => context.read<PaymentCubit>().pay(
                        amount: _amount,
                        description: 'Wallet payment',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
