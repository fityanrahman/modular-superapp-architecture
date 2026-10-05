import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class TransactionResultPage extends StatelessWidget {
  const TransactionResultPage({super.key, required this.result});

  final PaymentResult result;

  @override
  Widget build(BuildContext context) {
    final bool success = result.success;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(success ? 'Payment successful' : 'Payment failed'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? AppColors.success : AppColors.danger,
                size: 72,
              ),
              const SizedBox(height: 16),
              Text(
                result.message,
                style: AppTypography.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                result.transactionId ?? 'No transaction was created',
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Amount',
                      value: formatRupiah(result.amount),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Transaction',
                      value: result.transactionId ?? '-',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Done',
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.caption),
        Flexible(
          child: Text(
            value,
            style: AppTypography.title,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
