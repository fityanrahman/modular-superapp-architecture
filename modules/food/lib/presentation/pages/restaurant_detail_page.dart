import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/restaurant_detail_cubit.dart';
import '../food_dependencies.dart';
import '../widgets/food_item_tile.dart';

class RestaurantDetailPage extends StatelessWidget {
  const RestaurantDetailPage({
    super.key,
    required this.dependencies,
    required this.restaurant,
  });

  final FoodDependencies dependencies;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantDetailCubit>(
      create: (_) => RestaurantDetailCubit(
        restaurantId: restaurant.id,
        getRestaurantDetail: dependencies.getRestaurantDetail,
        getMenu: dependencies.getMenu,
      )..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(restaurant.name)),
        body: BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
          builder: (context, state) {
            return switch (state) {
              RestaurantDetailLoading() =>
                const AppLoading(message: 'Loading menu...'),
              RestaurantDetailError(:final String message) => AppErrorView(
                  message: message,
                  onRetry: () =>
                      context.read<RestaurantDetailCubit>().load(),
                ),
              RestaurantDetailLoaded(:final List<FoodItem> menu) =>
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: menu.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final FoodItem item = menu[index];
                    return BlocBuilder<CartCubit, Cart>(
                      buildWhen: (previous, current) =>
                          _quantity(previous, item.id) !=
                          _quantity(current, item.id),
                      builder: (context, cart) {
                        final int quantity = _quantity(cart, item.id);
                        return FoodItemTile(
                          item: item,
                          quantity: quantity,
                          onAdd: () => _add(context, item),
                          onRemove: () =>
                              context.read<CartCubit>().decrement(item),
                        );
                      },
                    );
                  },
                ),
            };
          },
        ),
      ),
    );
  }

  void _add(BuildContext context, FoodItem item) {
    context.read<CartCubit>().add(item, restaurant: restaurant);
    dependencies.analytics.track(
      'food_item_added',
      {'restaurantId': restaurant.id, 'itemId': item.id},
    );
  }

  int _quantity(Cart cart, String itemId) {
    final int index = cart.items.indexWhere((entry) => entry.item.id == itemId);
    return index < 0 ? 0 : cart.items[index].quantity;
  }
}
