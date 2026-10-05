import 'package:core/core.dart';
import 'package:contracts/contracts.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({
    super.key,
    required this.order,
    required this.payment,
  });

  final Order order;
  final PaymentResult payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 72,
              ),
              const SizedBox(height: 16),
              Text(
                'Your food is on the way!',
                style: AppTypography.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Order ${order.id}',
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Total paid',
                      value: formatRupiah(order.total),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Transaction',
                      value: payment.transactionId ?? '-',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Back to restaurants',
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
