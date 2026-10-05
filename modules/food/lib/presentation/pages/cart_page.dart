import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../bloc/cart_cubit.dart';
import '../food_dependencies.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.dependencies});

  final FoodDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: BlocBuilder<CartCubit, Cart>(
        builder: (context, cart) {
          if (cart.isEmpty) {
            return const Center(child: Text('Your cart is still empty.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final CartItem entry = cart.items[index];
                    return AppCard(
                      child: Row(
                        children: [
                          Text(
                            entry.item.imageEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.item.name,
                                  style: AppTypography.title,
                                ),
                                Text(
                                  formatRupiah(entry.subtotal),
                                  style: AppTypography.body,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                context.read<CartCubit>().decrement(entry.item),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('${entry.quantity}', style: AppTypography.title),
                          IconButton(
                            onPressed: () =>
                                context.read<CartCubit>().increment(entry.item),
                            icon: const Icon(
                              Icons.add_circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: AppTypography.title),
                          Text(
                            formatRupiah(cart.subtotal),
                            style: AppTypography.title,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Checkout',
                        icon: Icons.arrow_forward,
                        onPressed: () {
                          dependencies.analytics.track(
                            'food_checkout_started',
                            {'total': cart.subtotal},
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  CheckoutPage(dependencies: dependencies),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
