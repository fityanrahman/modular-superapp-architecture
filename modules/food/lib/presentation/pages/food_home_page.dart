import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/restaurant.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/restaurant_list_cubit.dart';
import '../food_dependencies.dart';
import '../widgets/restaurant_card.dart';
import 'cart_page.dart';
import 'restaurant_detail_page.dart';

class FoodHomePage extends StatelessWidget {
  const FoodHomePage({super.key, required this.dependencies});

  final FoodDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantListCubit>(
      create: (_) => RestaurantListCubit(dependencies.getRestaurants)..load(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).maybePop(),
          ),
          title: const Text('Food'),
          actions: [_CartButton(dependencies: dependencies)],
        ),
        body: BlocBuilder<RestaurantListCubit, RestaurantListState>(
          builder: (context, state) {
            return switch (state) {
              RestaurantListLoading() => const AppLoading(
                message: 'Loading restaurants...',
              ),
              RestaurantListError(:final String message) => AppErrorView(
                message: message,
                onRetry: () => context.read<RestaurantListCubit>().load(),
              ),
              RestaurantListLoaded(:final List<Restaurant> restaurants) =>
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: restaurants.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final Restaurant restaurant = restaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      onTap: () => _openRestaurant(context, restaurant),
                    );
                  },
                ),
            };
          },
        ),
      ),
    );
  }

  void _openRestaurant(BuildContext context, Restaurant restaurant) {
    dependencies.analytics.track('food_restaurant_opened', {
      'restaurantId': restaurant.id,
    });
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RestaurantDetailPage(
          dependencies: dependencies,
          restaurant: restaurant,
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.dependencies});

  final FoodDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, Cart>(
      buildWhen: (previous, current) =>
          previous.totalItems != current.totalItems,
      builder: (context, cart) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Badge.count(
            count: cart.totalItems,
            isLabelVisible: cart.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CartPage(dependencies: dependencies),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
