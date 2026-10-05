import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/checkout_cubit.dart';
import '../food_dependencies.dart';
import 'order_success_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.dependencies});

  final FoodDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final Cart cart = context.read<CartCubit>().state;
    return BlocProvider<CheckoutCubit>(
      create: (_) => CheckoutCubit(dependencies.placeFoodOrder),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            dependencies.analytics.track(
              'food_order_placed',
              {'orderId': state.order.id, 'total': state.order.total},
            );
            context.read<CartCubit>().clear();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => OrderSuccessPage(
                  order: state.order,
                  payment: state.payment,
                ),
              ),
            );
          } else if (state is CheckoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order summary', style: AppTypography.headline),
                    const SizedBox(height: 16),
                    AppCard(
                      child: Column(
                        children: [
                          for (final CartItem entry in cart.items)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${entry.quantity}x ${entry.item.name}',
                                      style: AppTypography.body,
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(entry.subtotal),
                                    style: AppTypography.body,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: AppTypography.title),
                        Text(
                          formatRupiah(cart.subtotal),
                          style: AppTypography.title,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Paid through the injected PaymentLauncher contract.',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Pay ${formatRupiah(cart.subtotal)}',
                      icon: Icons.lock_outline,
                      isLoading: state is CheckoutProcessing,
                      onPressed: () =>
                          context.read<CheckoutCubit>().submit(cart),
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
